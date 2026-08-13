import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // Define que o toast vai sumir sozinho após 5 segundos (5000ms)
    this.timeout = setTimeout(() => {
      this.close()
    }, 5000)
  }

  close() {
    // Adiciona as classes do Tailwind para fazer a animação de saída (fade out e deslizar)
    this.element.classList.remove('opacity-100', 'translate-x-0')
    this.element.classList.add('opacity-0', 'translate-x-full')
    
    // Aguarda a transição terminar (300ms) antes de remover o elemento do DOM
    setTimeout(() => {
      this.element.remove()
    }, 300)
  }

  // Prevenção de vazamento de memória
  disconnect() {
    clearTimeout(this.timeout)
  }
}