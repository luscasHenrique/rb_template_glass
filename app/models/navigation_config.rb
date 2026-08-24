class NavigationConfig
  ITEMS = [
    {
      title: "Dashboard",
      path: -> { Rails.application.routes.url_helpers.root_path },
      icon: "presentation-chart-bar",
      policy_record: :dashboard, 
      policy_action: :show?      
    },
    # ==========================================
    # NOVO GRUPO: AGENDA (Substitui o item único antigo)
    # ==========================================
    {
      title: "Agenda",
      section: "Produtividade", 
      icon: "calendar-days",
      policy_record: ScheduleItem, # O menu pai aparece se o usuário tiver acesso à agenda
      policy_action: :index?,
      sub_items: [
        {
          title: "Minha Agenda",
          path: -> { Rails.application.routes.url_helpers.schedule_items_path },
          policy_record: ScheduleItem,
          policy_action: :index?
        },
        {
          title: "Gerenciar Acessos",
          path: -> { Rails.application.routes.url_helpers.schedule_delegations_path },
          policy_record: ScheduleDelegation, # Trava de segurança para a nova Model
          policy_action: :index?
        }
      ]
    },
    # ==========================================
    {
      title: "Administração",
      section: "Gestão do Sistema",
      icon: "cog-6-tooth",
      policy_record: :dashboard,
      policy_action: :admin_area?,
      sub_items: [
        {
          title: "Usuários",
          path: -> { Rails.application.routes.url_helpers.admin_users_path },
          policy_record: [:admin, User], 
          policy_action: :index?        
        },
        {
          title: "Categorias de Agendamento",
          path: -> { Rails.application.routes.url_helpers.admin_schedule_categories_path },
          policy_record: [:admin, ScheduleCategory], 
          policy_action: :index?
        },
        {
          title: "Auditoria Global",
          path: -> { Rails.application.routes.url_helpers.admin_audit_logs_path },
          policy_record: [:admin, :audit_log],
          policy_action: :index?
        },
        {
          title: "Termos (LGPD)",
          path: -> { Rails.application.routes.url_helpers.policy_terms_path },
          policy_record: PolicyTerm, 
          policy_action: :index?    
        },
        {
          title: "Integrações (Rastreio)",
          path: -> { Rails.application.routes.url_helpers.tracking_integrations_path },
          policy_record: TrackingIntegration, 
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