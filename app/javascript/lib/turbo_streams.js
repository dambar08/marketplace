import { Turbo } from "@hotwired/turbo-rails"

Turbo.StreamActions.redirect = function () {
  const url = this.getAttribute("url")
  if (!url) return

  const frame = this.getAttribute("frame")
  if (frame) {
    Turbo.visit(url, { frame })
  } else {
    Turbo.visit(url)
  }
}

Turbo.StreamActions.reset_form = function () {
  this.targetElements.forEach((form) => form.reset())
}

Turbo.StreamActions.scroll_to = function () {
  const behavior = window.matchMedia("(prefers-reduced-motion: reduce)").matches ? "auto" : "smooth"

  this.targetElements.forEach((element) => {
    element.scrollIntoView({ behavior, block: "start" })
  })
}
