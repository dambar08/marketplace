import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["toggleable", "button"]
  static classes = ["hidden"]

  toggle(event) {
    event?.preventDefault()
    this.toggleableTargets.forEach((element) => element.classList.toggle(this.hiddenClassName))
    this.syncExpanded()
  }

  show(event) {
    event?.preventDefault()
    this.setOpen(true)
  }

  hide(event) {
    event?.preventDefault()
    this.setOpen(false)
  }

  setOpen(open) {
    this.toggleableTargets.forEach((element) => {
      element.classList.toggle(this.hiddenClassName, !open)
    })
    this.syncExpanded()
  }

  syncExpanded() {
    if (!this.hasButtonTarget || !this.hasToggleableTarget) return

    const open = this.toggleableTargets.some((element) => !element.classList.contains(this.hiddenClassName))
    this.buttonTargets.forEach((button) => button.setAttribute("aria-expanded", String(open)))
  }

  get hiddenClassName() {
    return this.hasHiddenClass ? this.hiddenClass : "hidden"
  }
}
