import { Turbo } from "@hotwired/turbo-rails"

document.addEventListener("turbo:frame-missing", (event) => {
  event.preventDefault()
  event.detail.visit(event.detail.response)
})

Turbo.config.forms.confirm = (message) => {
  const dialog = document.getElementById("turbo-confirm")
  const messageElement = dialog?.querySelector("[data-turbo-confirm-message]")

  if (!dialog || !messageElement) return Promise.resolve(confirm(message))

  messageElement.textContent = message
  if (!dialog.open) dialog.showModal()
  dialog.querySelector("[value='confirm']")?.focus()

  return new Promise((resolve) => {
    dialog.addEventListener("close", () => {
      resolve(dialog.returnValue === "confirm")
    }, { once: true })
  })
}
