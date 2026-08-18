import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["select", "buttonText", "menu", "option"]
  static classes = ["active", "inactive"]

  connect() {
    this.closeMenuOutside = this.closeMenuOutside.bind(this)
    document.addEventListener("click", this.closeMenuOutside)
    // Atualiza o visual ao carregar a página (caso venha do banco de dados)
    this.updateVisuals()
  }

  disconnect() {
    document.removeEventListener("click", this.closeMenuOutside)
  }

  toggle(event) {
    event.stopPropagation()
    this.menuTarget.classList.toggle("hidden")
  }

  // Diferença principal: Não fecha o menu ao clicar, permite selecionar vários!
  select(event) {
    event.stopPropagation()
    const selectedValue = event.currentTarget.dataset.value
    
    // Procura a tag <option> original no select oculto do Rails
    const option = Array.from(this.selectTarget.options).find(opt => opt.value === selectedValue)
    
    // Inverte o estado (se estava marcado, desmarca. Se não, marca)
    option.selected = !option.selected
    
    this.updateVisuals()
  }

  updateVisuals() {
    // 1. Pega tudo que está selecionado no select oculto
    const selectedOptions = Array.from(this.selectTarget.selectedOptions)
    const selectedValues = selectedOptions.map(opt => opt.value)
    const selectedTexts = selectedOptions.map(opt => opt.text)

    // 2. Muda a cor das opções no menu suspenso
    this.optionTargets.forEach(el => {
      if (selectedValues.includes(el.dataset.value)) {
        el.classList.add(...this.activeClasses)
        el.classList.remove(...this.inactiveClasses)
      } else {
        el.classList.remove(...this.activeClasses)
        el.classList.add(...this.inactiveClasses)
      }
    })

    // 3. Atualiza o texto do botão para o usuário (Ex: "Ruby, JS" ou "3 itens selecionados")
    if (selectedTexts.length === 0) {
      this.buttonTextTarget.innerText = this.element.dataset.placeholder || "Selecione..."
    } else if (selectedTexts.length <= 2) {
      this.buttonTextTarget.innerText = selectedTexts.join(", ")
    } else {
      this.buttonTextTarget.innerText = `${selectedTexts.length} itens selecionados`
    }
  }

  closeMenuOutside(event) {
    if (!this.element.contains(event.target)) {
      this.menuTarget.classList.add("hidden")
    }
  }
}