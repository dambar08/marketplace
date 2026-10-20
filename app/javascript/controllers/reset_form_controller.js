import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  reset(event) {
    if (event?.detail?.success === false) return

    this.element.reset()
  }
}
