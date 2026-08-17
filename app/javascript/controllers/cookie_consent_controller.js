import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["banner"]

  connect() {
    // Quando a página carrega, verifica se o cookie LGPD já existe.
    // Se NÃO existir, removemos a classe 'hidden' para o banner aparecer.
    if (!document.cookie.includes("cookie_consent=")) {
      this.bannerTarget.classList.remove("hidden")
    }
  }

  accept() {
    // Grava o cookie de aceite válido por 1 ano (365 dias)
    document.cookie = "cookie_consent=true; path=/; max-age=" + 60*60*24*365
    this.bannerTarget.classList.add("hidden")
    
    // Opcional, mas recomendado: Recarrega a página para que o Back-end (nosso IF do GTM) injete os scripts agora mesmo
    window.location.reload()
  }

  decline() {
    // Grava a recusa para não ficar enchendo o saco do usuário em todas as telas
    document.cookie = "cookie_consent=false; path=/; max-age=" + 60*60*24*365
    this.bannerTarget.classList.add("hidden")
  }
}