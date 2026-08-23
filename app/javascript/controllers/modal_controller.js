import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  // Define uma variável que o HTML pode passar para o JS (Padrão: Falso)
  static values = { autoOpen: { type: Boolean, default: false } }

  connect() {
    // Só abre sozinho se a View explicitamente autorizar
    if (this.autoOpenValue) {
      this.element.showModal()
    }
  }

  // Permite abrir via clique se precisarmos depois
  open() {
    this.element.showModal()
  }

  close() {
    this.element.close()
  }
}