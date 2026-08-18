import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "overlay" ]

  initialize() {
    this.show = this.show.bind(this)
    this.hide = this.hide.bind(this)
    this.handleLinkClick = this.handleLinkClick.bind(this)
  }

  connect() {
    console.log("✅ Loader: Modo Pragmático Ativado!") 
    
    // 1. Escuta qualquer envio de formulário na tela
    document.addEventListener("submit", this.show)
    
    // 2. Escuta qualquer clique na tela para interceptar os links
    document.addEventListener("click", this.handleLinkClick)
    
    // 3. Segurança: Oculta o loader se o usuário usar o botão "Voltar" do navegador
    window.addEventListener("pageshow", this.hide)
    
    // 4. Mantém o Turbo Load apenas por garantia (para telas que usam Turbo)
    document.addEventListener("turbo:load", this.hide)
  }

  disconnect() {
    document.removeEventListener("submit", this.show)
    document.removeEventListener("click", this.handleLinkClick)
    window.removeEventListener("pageshow", this.hide)
    document.removeEventListener("turbo:load", this.hide)
  }

  handleLinkClick(event) {
    // Procura se o elemento clicado (ou o pai dele) é uma tag <a>
    const link = event.target.closest('a')
    
    if (link) {
      // Ignora links que são apenas âncoras (ex: "#") ou que abrem em nova aba
      const isAnchor = link.getAttribute('href') && link.getAttribute('href').startsWith('#')
      const isNewTab = link.target === '_blank'
      
      // Se for um link legítimo de navegação, mostra o loader!
      if (!isAnchor && !isNewTab) {
        this.show()
      }
    }
  }

  show() {
    this.overlayTarget.classList.remove("hidden")
    this.overlayTarget.classList.add("flex")
  }

  hide() {
    this.overlayTarget.classList.add("hidden")
    this.overlayTarget.classList.remove("flex")
  }
}