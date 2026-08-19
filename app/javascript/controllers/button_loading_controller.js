import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["normal", "loading"]

  load(event) {
    // Regra de Negócio de Prevenção: 
    // Se for um botão de "submit", verificamos se os campos obrigatórios do form estão preenchidos.
    // Se não estiverem, abortamos o loading para o HTML5 exibir os erros em vermelho.
    if (this.element.type === "submit") {
      const form = this.element.closest("form")
      if (form && !form.checkValidity()) return
    }

    // 1. Troca os estados visuais
    this.normalTarget.classList.add("hidden")
    this.normalTarget.classList.remove("flex")

    this.loadingTarget.classList.remove("hidden")
    this.loadingTarget.classList.add("flex")

    // 2. Trava o botão para evitar duplicação de requisições (Double Submit)
    this.element.classList.add("opacity-70", "cursor-wait", "pointer-events-none")
  }
}