class NavigationConfig
  ITEMS = [
    {
      title: "Dashboard",
      path: -> { Rails.application.routes.url_helpers.root_path },
      icon: "presentation-chart-bar",
      policy_record: :dashboard, # Referencia a DashboardPolicy
      policy_action: :show?      # Chama o método show?
    },
    {
      title: "Cadastros",
      section: "Administração",
      icon: "users",
      policy_record: :dashboard,
      policy_action: :admin_area?, # Só exibe se for admin
      sub_items: [
        {
          title: "Usuários",
          path: -> { "#" },
          policy_record: :dashboard,
          policy_action: :admin_area?
        },
        {
          title: "Termos de Uso (LGPD)",
          path: -> { Rails.application.routes.url_helpers.policy_terms_path },
          policy_record: PolicyTerm, # Passa a Classe Base para o Pundit
          policy_action: :index?     # O menu só aparece se ele puder acessar o index
        }
      ]
    },
    {
      title: "Configurações",
      section: "Administração",
      path: -> { "#" },
      icon: "cog-6-tooth",
      policy_record: :dashboard,
      policy_action: :admin_area?
    }
  ].freeze

  def self.for(user)
    return [] unless user

    # Filtra os itens principais consultando o Pundit
    allowed_items = ITEMS.select do |item|
      Pundit.policy(user, item[:policy_record]).public_send(item[:policy_action])
    end

    # Filtra os sub_items se eles existirem
    allowed_items.map do |item|
      if item[:sub_items]
        item[:sub_items] = item[:sub_items].select do |sub_item|
          Pundit.policy(user, sub_item[:policy_record]).public_send(sub_item[:policy_action])
        end
      end
      item
    end
  end
end
