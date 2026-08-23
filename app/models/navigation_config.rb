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
      title: "Minha Agenda",
      section: "Produtividade", 
      path: -> { Rails.application.routes.url_helpers.schedule_items_path },
      icon: "calendar-days",
      policy_record: ScheduleItem, # Trava de segurança apontando para a Model
      policy_action: :index?       # Exige permissão na Policy
    },
    {
      title: "Administração",
      section: "Gestão do Sistema",
      icon: "cog-6-tooth",
      policy_record: :dashboard,
      policy_action: :admin_area?, # Só exibe o menu pai se for admin
      sub_items: [
        {
          title: "Usuários",
          path: -> { Rails.application.routes.url_helpers.admin_users_path },
          policy_record: [:admin, User], # Delega a segurança para a Admin::UserPolicy
          policy_action: :index?         # Só mostra o menu se o usuário puder acessar o index
        },
        {
          title: "Tipos de Agendamento",
          path: -> { Rails.application.routes.url_helpers.admin_schedule_categories_path },
          policy_record: [:admin, ScheduleCategory], # Usa a nossa Policy restrita!
          policy_action: :index?
        },
        {
          title: "Auditoria Global",
          path: -> { Rails.application.routes.url_helpers.admin_audit_logs_path },
          policy_record: [:admin, :audit_log], # Chama nossa nova Policy
          policy_action: :index?
        },
        {
          title: "Termos (LGPD)",
          path: -> { Rails.application.routes.url_helpers.policy_terms_path },
          policy_record: PolicyTerm, # Passa a Classe Base para o Pundit
          policy_action: :index?     # O menu só aparece se ele puder acessar o index
        },
        {
          title: "Integrações (Rastreio)",
          path: -> { Rails.application.routes.url_helpers.tracking_integrations_path },
          policy_record: TrackingIntegration, # Nossa nova trava de segurança
          policy_action: :index?
        }
      ]
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