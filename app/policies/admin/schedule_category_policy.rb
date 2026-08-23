module Admin
  class ScheduleCategoryPolicy < ApplicationPolicy
    def index?
      user_is_management?
    end

    def create?
      user_is_management?
    end

    def update?
      user_is_management?
    end

    def destroy?
      user_is_management?
    end

    private

    # Regra centralizada: Apenas gestores têm acesso ao Backoffice de Categorias
    def user_is_management?
      user.present? && (user.admin? || user.manager? || user.master?)
    end
  end
end