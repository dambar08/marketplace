import { Application } from "@hotwired/stimulus"

const application = Application.start()

application.debug = document.querySelector("meta[name='stimulus-debug']")?.content === "true"
window.Stimulus = application

export { application }
