import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dialog"]

  open(event) {
    event?.preventDefault()
    if (!this.dialogElement.open) this.dialogElement.showModal()
  }

  close(event) {
    event?.preventDefault()
    this.dialogElement.close()
  }

  backdrop(event) {
    if (event.target === this.dialogElement) this.dialogElement.close()
  }

  get dialogElement() {
    return this.hasDialogTarget ? this.dialogTarget : this.element
  }
}
