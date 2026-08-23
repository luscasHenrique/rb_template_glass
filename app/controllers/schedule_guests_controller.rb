class ScheduleGuestsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_schedule_guest

  def update
    authorize @schedule_guest 

    if @schedule_guest.update(guest_params)
      redirect_to request.referer || root_path, notice: "Sua presença foi atualizada com sucesso!"
    else
      redirect_to request.referer || root_path, alert: "Não foi possível atualizar o status."
    end
  end

  def destroy
    authorize @schedule_guest
    @schedule_guest.destroy
    
    redirect_to request.referer || root_path, notice: "Convidado removido do evento."
  end

  private

  def set_schedule_guest
    @schedule_guest = ScheduleGuest.find(params[:id])
  end

  def guest_params
    params.require(:schedule_guest).permit(:status)
  end
end