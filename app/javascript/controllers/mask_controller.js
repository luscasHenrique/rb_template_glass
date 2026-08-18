import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { pattern: String } 

  connect() {
    this.formatHandler = this.format.bind(this)
    this.element.addEventListener("input", this.formatHandler)
    
    // Formata imediatamente o valor assim que a tela abre (fix para dados vindos do banco)
    this.format()
  }

  disconnect() {
    this.element.removeEventListener("input", this.formatHandler)
  }

  format() {
    if (!this.hasPatternValue || !this.element.value) return

    // Usamos diretamente 'this.element' em vez de depender de evento
    const rawValue = this.element.value.replace(/\D/g, "") 
    const pattern = this.patternValue
    
    let formattedValue = ""
    let valueIndex = 0

    for (let i = 0; i < pattern.length; i++) {
      if (valueIndex >= rawValue.length) break

      if (pattern[i] === "0") {
        formattedValue += rawValue[valueIndex]
        valueIndex++
      } else {
        formattedValue += pattern[i]
      }
    }

    this.element.value = formattedValue
  }
}