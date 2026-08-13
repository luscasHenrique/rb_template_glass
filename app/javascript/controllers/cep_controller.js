import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["zipcode", "street", "city", "state"]

  async search() {
    // Remove qualquer coisa que não seja número do CEP digitado
    let cep = this.zipcodeTarget.value.replace(/\D/g, '')
    
    if (cep.length === 8) {
      try {
        const response = await fetch(`https://viacep.com.br/ws/${cep}/json/`)
        const data = await response.json()
        
        if (!data.erro) {
          if (this.hasStreetTarget) this.streetTarget.value = data.logradouro
          if (this.hasCityTarget) this.cityTarget.value = data.localidade
          if (this.hasStateTarget) this.stateTarget.value = data.uf
          
          // Foco automático no campo de número (Melhoria de UX)
          const numberField = document.querySelector('[name*="[number]"]')
          if (numberField) numberField.focus()
        }
      } catch (error) {
        console.error("Erro ao consultar ViaCEP:", error)
      }
    }
  }
}