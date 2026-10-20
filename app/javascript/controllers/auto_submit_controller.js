import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { delay: { type: Number, default: 300 } }

  disconnect() {
    clearTimeout(this.timeout)
  }

  submit() {
    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => {
      if (typeof this.form.requestSubmit === "function") this.form.requestSubmit()
    }, this.delayValue)
  }

  get form() {
    return this.element.closest("form") || this.element
  }
}
