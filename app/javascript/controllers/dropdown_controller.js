import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu", "button"]
  static values = { open: Boolean }

  onOutsideClick = (event) => {
    if (!this.element.contains(event.target)) this.close()
  }

  onEscape = (event) => {
    if (event.key !== "Escape" || !this.openValue) return

    this.close()
    if (this.hasButtonTarget) this.buttonTarget.focus()
  }

  disconnect() {
    this.teardown()
  }

  toggle(event) {
    event.preventDefault()
    this.openValue = !this.openValue
  }

  close() {
    this.openValue = false
  }

  openValueChanged() {
    if (!this.hasMenuTarget) return

    this.menuTarget.classList.toggle("hidden", !this.openValue)
    if (this.hasButtonTarget) {
      this.buttonTarget.setAttribute("aria-expanded", String(this.openValue))
      this.buttonTarget.setAttribute("aria-haspopup", "true")
    }

    this.teardown()
    if (!this.openValue) return

    document.addEventListener("click", this.onOutsideClick)
    document.addEventListener("keydown", this.onEscape)
  }

  teardown() {
    document.removeEventListener("click", this.onOutsideClick)
    document.removeEventListener("keydown", this.onEscape)
  }
}
