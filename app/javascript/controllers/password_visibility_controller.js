import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "iconOpen", "iconClosed"]

  toggle(event) {
    event.preventDefault() // Evita que o botão submeta o formulário acidentalmente

    if (this.inputTarget.type === "password") {
      this.inputTarget.type = "text"
      this.iconOpenTarget.classList.remove("hidden")
      this.iconClosedTarget.classList.add("hidden")
    } else {
      this.inputTarget.type = "password"
      this.iconOpenTarget.classList.add("hidden")
      this.iconClosedTarget.classList.remove("hidden")
    }
  }
}