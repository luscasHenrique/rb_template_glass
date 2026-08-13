import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["aside", "text", "footerText", "toggleIcon", "tooltip", "centerWrapper", "backdrop"]

  // --- MÉTODOS DE AÇÃO GERAIS ---
  toggle() {
    const isCollapsed = this.asideTarget.classList.contains("w-20")
    if (isCollapsed) {
      this.expand()
    } else {
      this.collapse()
    }
  }

  // --- LÓGICA DE MOBILE ---
  toggleMobile() {
    const isClosed = this.asideTarget.classList.contains("-translate-x-[120%]")

    if (isClosed) {
      this.expand()
      // Desliza a barra para dentro da tela
      this.asideTarget.classList.remove("-translate-x-[120%]")
      
      // Animação suave do Backdrop (Fade In)
      if (this.hasBackdropTarget) {
        this.backdropTarget.classList.remove("opacity-0", "pointer-events-none")
        this.backdropTarget.classList.add("opacity-100", "pointer-events-auto")
      }
    } else {
      this.closeMobile()
    }
  }

  closeMobile() {
    if (window.innerWidth < 768) {
      // Desliza a barra para fora da tela
      this.asideTarget.classList.add("-translate-x-[120%]")
      
      // Animação suave do Backdrop (Fade Out)
      if (this.hasBackdropTarget) {
        this.backdropTarget.classList.remove("opacity-100", "pointer-events-auto")
        this.backdropTarget.classList.add("opacity-0", "pointer-events-none")
      }
    }
  }
  // --- LÓGICA DE SUBMENU (ACCORDION) ---
  toggleSubmenu(event) {
    if (this.asideTarget.classList.contains("w-20")) {
      this.expand()
    }

    const button = event.currentTarget
    const submenu = button.nextElementSibling
    const chevron = button.querySelector('.submenu-chevron')

    submenu.classList.toggle("hidden")
    if (chevron) chevron.classList.toggle("rotate-180")
  }

  // --- MÉTODOS DE ESTADO (Reusáveis) ---
  expand() {
    this.asideTarget.classList.remove("w-20")
    this.asideTarget.classList.add("w-64")
    
    if (this.hasToggleIconTarget) this.toggleIconTarget.classList.remove("rotate-180")

    this.textTargets.forEach(el => el.classList.remove("hidden"))
    this.footerTextTargets.forEach(el => el.classList.remove("hidden"))
    this.tooltipTargets.forEach(el => el.classList.add("hidden"))
    
    this.centerWrapperTargets.forEach(el => el.classList.remove("justify-center"))
  }

  collapse() {
    this.asideTarget.classList.remove("w-64")
    this.asideTarget.classList.add("w-20")
    
    if (this.hasToggleIconTarget) this.toggleIconTarget.classList.add("rotate-180")

    this.textTargets.forEach(el => el.classList.add("hidden"))
    this.footerTextTargets.forEach(el => el.classList.add("hidden"))
    this.tooltipTargets.forEach(el => el.classList.remove("hidden"))

    this.centerWrapperTargets.forEach(el => el.classList.add("justify-center"))

    // --- NOVA LÓGICA: Fechar todos os submenus ao recolher a barra ---
    const openSubmenus = this.asideTarget.querySelectorAll('.submenu-list:not(.hidden)')
    openSubmenus.forEach(submenu => {
      submenu.classList.add("hidden")
      const button = submenu.previousElementSibling
      if (button) {
        const chevron = button.querySelector('.submenu-chevron')
        if (chevron) chevron.classList.remove("rotate-180")
      }
    })
  }
}