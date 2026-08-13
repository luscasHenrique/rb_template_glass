class NavigationConfig
  ITEMS = [
    {
      title: "Dashboard",
      path: -> { Rails.application.routes.url_helpers.root_path },
      icon: "presentation-chart-bar", # Nome válido no Heroicons para a grade de Dashboard
      roles: [:user, :admin ]
    },
    {
      title: "Cadastros",          # Item pai (não tem path direto, serve de gatilho)
      section: "Administração",
      icon: "users",
      roles: [:admin],
      sub_items: [                 # Array de subitens
        {
          title: "Usuários",
          path: -> { "#" },        # Ex: users_path
          roles: [:admin]
        },
        {
          title: "Empresas",
          path: -> { "#" },        # Ex: companies_path
          roles: [:admin]
        }
      ]
    },
    {
      title: "Configurações",
      section: "Administração",
      path: -> { "#" },
      icon: "cog-6-tooth", # Nome válido no Heroicons para Engrenagem/Settings
      roles: [:admin]
    }

  ].freeze

  def self.for(user)
    return [] unless user
    ITEMS.select { |item| item[:roles].include?(user.role.to_sym) }
  end
end