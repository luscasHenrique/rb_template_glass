class ScheduleItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_schedule_item, only: [:show, :edit, :update, :destroy]

  def index
    # O Pundit Scope garante que o usuário só veja na tela inicial os eventos
    # que ele criou ou para os quais foi convidado.
    @schedule_items = policy_scope(ScheduleItem)
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
    @schedule_item = current_user.created_schedule_items.build(schedule_item_params)
    authorize @schedule_item

    if @schedule_item.save
      redirect_to schedule_items_path, notice: "Agendamento criado com sucesso."
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