module Admin
  class ScheduleCategoriesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_schedule_category, only: [:edit, :update, :destroy]

    def index
      # Lista as categorias em ordem alfabética para facilitar a gestão
      @schedule_categories = ScheduleCategory.order(:name)
      authorize [:admin, ScheduleCategory]
    end

    def new
      @schedule_category = ScheduleCategory.new
      # Como definimos um padrão (default) no banco, podemos iniciar como ativa
      @schedule_category.active = true 
      authorize [:admin, @schedule_category]
    end

    def create
      @schedule_category = ScheduleCategory.new(category_params)
      authorize [:admin, @schedule_category]

      if @schedule_category.save
        redirect_to admin_schedule_categories_path, notice: "Categoria criada com sucesso."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      authorize [:admin, @schedule_category]
    end

    def update
      authorize [:admin, @schedule_category]

      if @schedule_category.update(category_params)
        redirect_to admin_schedule_categories_path, notice: "Categoria atualizada com sucesso."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      authorize [:admin, @schedule_category]
      
      # Dica de Tech Lead: O 'dependent: :nullify' na Model garante que 
      # se apagarmos uma categoria, os agendamentos antigos não quebram (apenas ficam sem categoria).
      @schedule_category.destroy
      
      redirect_to admin_schedule_categories_path, notice: "Categoria removida permanentemente."
    end

    private

    def set_schedule_category
      @schedule_category = ScheduleCategory.find(params[:id])
    end

    def category_params
      # Blinda a entrada de dados (Strong Parameters)
      params.require(:schedule_category).permit(:name, :color, :icon, :active)
    end
  end
end