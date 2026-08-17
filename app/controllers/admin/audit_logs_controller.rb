class Admin::AuditLogsController < ApplicationController
  def index
    authorize [:admin, :audit_log]

    # Inicia a query limitando a 500 registros para proteger a memória do servidor
    @versions = PaperTrail::Version.order(created_at: :desc).limit(500)

    # 1. Filtros Básicos (Entidade e Ação)
    @versions = @versions.where(item_type: params[:item_type]) if params[:item_type].present?
    @versions = @versions.where(event: params[:event]) if params[:event].present?

    # 2. Filtro por E-mail do Operador (Tradução de UX para ID)
    if params[:operator_email].present?
      # Busca usuários cujo e-mail contenha o texto digitado (ILIKE ignora maiúsculas/minúsculas)
      user_ids = User.where("email ILIKE ?", "%#{params[:operator_email]}%").pluck(:id)
      
      # Filtra a caixa preta apenas com os IDs encontrados
      @versions = @versions.where(whodunnit: user_ids.map(&:to_s))
    end

    # 3. Filtro de Datas (Range)
    if params[:start_date].present?
      # beginning_of_day garante que pega desde as 00:00:00 daquele dia
      @versions = @versions.where("created_at >= ?", Time.zone.parse(params[:start_date]).beginning_of_day)
    end

    if params[:end_date].present?
      # end_of_day garante que pega até as 23:59:59 daquele dia
      @versions = @versions.where("created_at <= ?", Time.zone.parse(params[:end_date]).end_of_day)
    end

    # =====================================================================
    # PERFORMANCE (Prevenção de N+1 Queries)
    # =====================================================================
    # Em vez de fazer uma consulta no banco para cada linha da tabela pedindo o e-mail do usuário,
    # nós pegamos todos os IDs da página de uma vez, fazemos uma única query, e indexamos na memória.
    operator_ids = @versions.filter_map(&:whodunnit).uniq
    @operators = User.where(id: operator_ids).index_by { |u| u.id.to_s }
  end
end