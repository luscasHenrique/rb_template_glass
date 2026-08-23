module ThemeHelper
  # =====================================================================
  # DESIGN SYSTEM: FONTE DA VERDADE PARA CORES DINÂMICAS (GLASSMORPHISM)
  # =====================================================================
  def glass_theme_classes(color_name, component_type = :badge)
    themes = {
      "blue"   => {
        badge: "text-blue-400 bg-blue-500/10 border-blue-500/30",
        pill:  "bg-blue-500/20 text-blue-200 border-blue-500/30 hover:bg-blue-500/40"
      },
      "green"  => {
        badge: "text-emerald-400 bg-emerald-500/10 border-emerald-500/30",
        pill:  "bg-emerald-500/20 text-emerald-200 border-emerald-500/30 hover:bg-emerald-500/40"
      },
      "red"    => {
        badge: "text-rose-400 bg-rose-500/10 border-rose-500/30",
        pill:  "bg-rose-500/20 text-rose-200 border-rose-500/30 hover:bg-rose-500/40"
      },
      "orange" => {
        badge: "text-amber-400 bg-amber-500/10 border-amber-500/30",
        pill:  "bg-amber-500/20 text-amber-200 border-amber-500/30 hover:bg-amber-500/40"
      },
      "violet" => {
        badge: "text-violet-400 bg-violet-500/10 border-violet-500/30",
        pill:  "bg-violet-500/20 text-violet-200 border-violet-500/30 hover:bg-violet-500/40"
      },
      "cyan"   => {
        badge: "text-cyan-400 bg-cyan-500/10 border-cyan-500/30",
        pill:  "bg-cyan-500/20 text-cyan-200 border-cyan-500/30 hover:bg-cyan-500/40"
      }
    }
    
    # Prevenção de falhas: se a cor não existir, cai para o padrão (violeta)
    safe_color = themes.key?(color_name.to_s) ? color_name.to_s : "violet"
    
    # Retorna as classes específicas para o tipo de componente (badge de tabela ou pílula de calendário)
    themes[safe_color][component_type]
  end
end