{{- define "marketplace.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "marketplace.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{- define "marketplace.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "marketplace.labels" -}}
helm.sh/chart: {{ include "marketplace.chart" . }}
{{ include "marketplace.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: marketplace
{{- end }}

{{- define "marketplace.selectorLabels" -}}
app.kubernetes.io/name: {{ include "marketplace.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "marketplace.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "marketplace.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "marketplace.secretName" -}}
{{- if .Values.rails.existingSecret }}
{{- .Values.rails.existingSecret }}
{{- else }}
{{- printf "%s-env" (include "marketplace.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{- define "marketplace.image" -}}
{{- printf "%s:%s" .Values.image.repository (.Values.image.tag | default .Chart.AppVersion) }}
{{- end }}

{{- define "marketplace.postgres.fullname" -}}
{{- printf "%s-postgres" (include "marketplace.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "marketplace.redis.fullname" -}}
{{- printf "%s-redis" (include "marketplace.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "marketplace.database.host" -}}
{{- if .Values.database.bundled }}
{{- include "marketplace.postgres.fullname" . }}
{{- else }}
{{- required "database.host is required when database.bundled is false" .Values.database.host }}
{{- end }}
{{- end }}

{{- define "marketplace.redis.host" -}}
{{- if .Values.redis.host }}
{{- .Values.redis.host }}
{{- else if .Values.redis.bundled }}
{{- include "marketplace.redis.fullname" . }}
{{- end }}
{{- end }}

{{- define "marketplace.redis.url" -}}
{{- if .Values.redis.url }}
{{- .Values.redis.url }}
{{- else if .Values.redis.bundled }}
{{- printf "redis://%s:%v/0" (include "marketplace.redis.fullname" .) .Values.redis.port }}
{{- else }}
{{- fail "Set redis.url when redis.bundled is false" }}
{{- end }}
{{- end }}

{{- define "marketplace.storageClass" -}}
{{- if .storageClass }}
{{- if eq .storageClass "-" }}
storageClassName: ""
{{- else }}
storageClassName: {{ .storageClass | quote }}
{{- end }}
{{- end }}
{{- end }}

{{- define "marketplace.imagePullSecrets" -}}
{{- with .Values.imagePullSecrets }}
imagePullSecrets:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- end }}

{{- define "marketplace.scheduling" -}}
{{- with .Values.nodeSelector }}
nodeSelector:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- with .Values.affinity }}
affinity:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- with .Values.tolerations }}
tolerations:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- end }}

{{- define "marketplace.volumeMounts" -}}
- name: storage
  mountPath: /rails/storage
- name: tmp
  mountPath: /rails/tmp
{{- end }}

{{- define "marketplace.podVolumes" -}}
- name: storage
  {{- if .Values.persistence.enabled }}
  persistentVolumeClaim:
    claimName: {{ include "marketplace.fullname" . }}-storage
  {{- else }}
  emptyDir: {}
  {{- end }}
- name: tmp
  emptyDir: {}
{{- end }}

{{- define "marketplace.envFrom" -}}
envFrom:
  - configMapRef:
      name: {{ include "marketplace.fullname" . }}
  - secretRef:
      name: {{ include "marketplace.secretName" . }}
{{- end }}

{{- define "marketplace.validate" -}}
{{- if and .Values.persistence.enabled (eq .Values.persistence.accessMode "ReadWriteOnce") (gt (int .Values.web.replicaCount) 1) }}
{{- fail "web.replicaCount > 1 needs persistence.accessMode=ReadWriteMany or persistence.enabled=false" }}
{{- end }}
{{- if and .Values.persistence.enabled .Values.autoscaling.enabled (eq .Values.persistence.accessMode "ReadWriteOnce") (gt (int .Values.autoscaling.maxReplicas) 1) }}
{{- fail "autoscaling above 1 replica needs ReadWriteMany or persistence.enabled=false" }}
{{- end }}
{{- if and .Values.sidekiq.enabled (not .Values.sidekiq.asSidecar) .Values.persistence.enabled (eq .Values.persistence.accessMode "ReadWriteOnce") }}
{{- fail "sidekiq.asSidecar must stay true while Active Storage uses a ReadWriteOnce volume" }}
{{- end }}
{{- if not (or .Values.rails.masterKey .Values.rails.existingSecret) }}
{{- fail "Set rails.masterKey or rails.existingSecret" }}
{{- end }}
{{- if and (not .Values.redis.bundled) (not .Values.redis.url) }}
{{- fail "Set redis.url when redis.bundled is false" }}
{{- end }}
{{- if and (not .Values.redis.bundled) (not .Values.redis.host) }}
{{- fail "Set redis.host when redis.bundled is false" }}
{{- end }}
{{- if and (not .Values.database.bundled) (not .Values.database.host) }}
{{- fail "Set database.host when database.bundled is false" }}
{{- end }}
{{- end }}

{{- define "marketplace.initContainers" -}}
- name: prepare
  image: {{ include "marketplace.image" . }}
  imagePullPolicy: {{ .Values.image.pullPolicy }}
  securityContext:
    {{- toYaml .Values.containerSecurityContext | nindent 4 }}
  command:
    - bash
    - -c
    - |
      until pg_isready -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USERNAME"; do
        echo "waiting for postgres at ${DB_HOST}:${DB_PORT}"
        sleep 2
      done
      if [ -n "${REDIS_HOST}" ]; then
        until (echo > /dev/tcp/${REDIS_HOST}/${REDIS_PORT}) 2>/dev/null; do
          echo "waiting for redis at ${REDIS_HOST}:${REDIS_PORT}"
          sleep 2
        done
      fi
      until ./bin/rails db:prepare; do
        echo "db:prepare failed; retrying"
        sleep 3
      done
  {{- include "marketplace.envFrom" . | nindent 2 }}
{{- end }}

{{- define "marketplace.sidekiqContainer" -}}
- name: sidekiq
  image: {{ include "marketplace.image" . }}
  imagePullPolicy: {{ .Values.image.pullPolicy }}
  command: ["bundle", "exec", "sidekiq", "-C", "config/sidekiq.yml"]
  securityContext:
    {{- toYaml .Values.containerSecurityContext | nindent 4 }}
  {{- include "marketplace.envFrom" . | nindent 2 }}
  {{- with .Values.sidekiq.resources }}
  resources:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  readinessProbe:
    exec:
      command: ["bash", "-c", "echo > /dev/tcp/${REDIS_HOST}/${REDIS_PORT}"]
    initialDelaySeconds: 5
    periodSeconds: 10
    timeoutSeconds: 3
    failureThreshold: 6
  volumeMounts:
    {{- include "marketplace.volumeMounts" . | nindent 4 }}
{{- end }}
