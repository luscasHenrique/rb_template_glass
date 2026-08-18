import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  // Declaramos os targets e as classes dinâmicas esperadas do HTML
  static targets = ["input", "buttonText", "menu", "option"]
  static classes = ["active", "inactive"]

  connect() {
    // Faz o bind seguro para podermos remover o evento depois
    this.closeMenuOutside = this.closeMenuOutside.bind(this)
    // Escuta cliques no documento inteiro para fechar o select se clicar fora
    document.addEventListener("click", this.closeMenuOutside)
  }

  disconnect() {
    document.removeEventListener("click", this.closeMenuOutside)
  }

  // Abre/Fecha o dropdown
  toggle(event) {
    event.stopPropagation() // Evita que o clique feche o menu imediatamente
    this.menuTarget.classList.toggle("hidden")
  }

  // Ação ao clicar em uma opção
  select(event) {
    const selectedValue = event.currentTarget.dataset.value
    const selectedText = event.currentTarget.innerText

    // 1. Atualiza o input oculto para o Rails salvar no backend
    this.inputTarget.value = selectedValue
    
    // 2. Atualiza o texto que o usuário vê no botão
    this.buttonTextTarget.innerText = selectedText

    // 3. Esconde o menu
    this.menuTarget.classList.add("hidden")

    // 4. Atualiza o estado visual das opções consumindo a API de Classes
    this.optionTargets.forEach(el => {
      if (el.dataset.value === selectedValue) {
        el.classList.add(...this.activeClasses)
        el.classList.remove(...this.inactiveClasses)
      } else {
        el.classList.remove(...this.activeClasses)
        el.classList.add(...this.inactiveClasses)
      }
    })
  }

  // Função de segurança: clica fora, menu fecha
  closeMenuOutside(event) {
    if (!this.element.contains(event.target)) {
      this.menuTarget.classList.add("hidden")
    }
  }
}