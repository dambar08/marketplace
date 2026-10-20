import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]
  static values = { shown: Boolean }

  toggle(event) {
    event?.preventDefault()
    this.shownValue = !this.shownValue
  }

  shownValueChanged() {
    if (!this.hasInputTarget) return

    this.inputTarget.type = this.shownValue ? "text" : "password"
  }
}
