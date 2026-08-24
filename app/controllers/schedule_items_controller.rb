class ScheduleItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_schedule_item, only: [:show, :edit, :update, :destroy]

def index
    # 1. Carrega a base autorizada pela Policy
    base_scope = policy_scope(ScheduleItem)
    
    # 2. Lógica de Troca de Contexto (Assistente acessando agenda do Gestor)
    if params[:manager_id].present?
      # Segurança: Garante que o usuário logado realmente é assistente deste gestor específico
      if current_user.delegators.exists?(id: params[:manager_id])
        @manager = User.find(params[:manager_id])
        # Filtra para mostrar apenas os eventos onde o gestor é o dono
        @schedule_items = base_scope.where(creator_id: @manager.id)
      else
        redirect_to schedule_items_path, alert: "Acesso negado: Você não gerencia esta agenda."
        return
      end
    else
      # 3. Comportamento Padrão: Vê a própria agenda
      @schedule_items = base_scope.where(creator_id: current_user.id)
    end

    authorize ScheduleItem
  end

  def show
    authorize @schedule_item
  end

  def new
    @schedule_item = ScheduleItem.new
    authorize @schedule_item
    
    # Pré-preenche a data se o usuário clicou em um dia específico no calendário
    @schedule_item.start_time = params[:start_date] if params[:start_date].present?
  end

  def edit
    authorize @schedule_item
  end

def create
    # 1. Identifica se estamos em modo de delegação
    manager_id = params[:manager_id]
    creator = current_user

    # 2. Trava de Segurança: Só permite criar em nome do gestor se for um delegado válido
    if manager_id.present? && current_user.delegators.exists?(id: manager_id)
      creator = User.find(manager_id)
    end

    # 3. Cria o evento atrelado ao dono correto
    @schedule_item = creator.created_schedule_items.build(schedule_item_params)
    authorize @schedule_item

    if @schedule_item.save
      # Mantém o usuário na agenda do gestor após salvar
      redirect_to schedule_items_path(manager_id: manager_id), notice: "Agendamento criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    authorize @schedule_item

    if @schedule_item.update(schedule_item_params)
    # Redireciona de volta para o calendário
    redirect_to schedule_items_path, notice: "Agendamento atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @schedule_item
    @schedule_item.destroy
    
    redirect_to root_path, notice: "Agendamento cancelado com sucesso."
  end

  private

  def set_schedule_item
    @schedule_item = ScheduleItem.find(params[:id])
  end

def schedule_item_params
    params.require(:schedule_item).permit(
      :title, :description, :start_time, :end_time, 
      :meeting_url, :schedule_category_id, :location_type, :location_id,
      guest_ids: []
    )
  end
end