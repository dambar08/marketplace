import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["source", "button"]
  static values = {
    text: String,
    success: { type: String, default: "Copied" },
    duration: { type: Number, default: 2000 }
  }

  disconnect() {
    clearTimeout(this.timeout)
  }

  async copy(event) {
    event?.preventDefault()
    const text = this.copyText
    if (!text) return

    try {
      await navigator.clipboard.writeText(text)
    } catch {
      return
    }

    this.showSuccess()
  }

  showSuccess() {
    if (!this.hasButtonTarget) return

    const button = this.buttonTarget
    const original = button.textContent
    button.textContent = this.successValue
    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => {
      button.textContent = original
    }, this.durationValue)
  }

  get copyText() {
    if (this.hasTextValue) return this.textValue
    if (!this.hasSourceTarget) return ""

    const source = this.sourceTarget
    return ("value" in source ? source.value : source.textContent).trim()
  }
}
