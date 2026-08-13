class DashboardPolicy < ApplicationPolicy
  # Nenhuma tabela de banco amarrada, é uma política "Headless" apenas para tela

  def show?
    # Quem pode ver o Dashboard? Qualquer usuário logado.
    user.present?
  end

  def admin_area?
    # Quem pode ver a área de administração? Apenas admins.
    user.admin?
  end

  #   # Regra 3 (A SUA DÚVIDA): Apenas usuários comuns, bloqueia admin e manager
  #   def user_only_area?
  #     user.user? # Retorna true só se o enum for 0 (user)
  #   end

  #   # Regra 4: Admin OU Manager podem acessar
  #   def backoffice_access?
  #     user.admin? || user.manager?
  #   end

  #   # Padrão Escalável: Cria uma lista e verifica se o usuário pertence a ela
  # def relatorio_financeiro?
  #     %w[admin manager auditor financeiro].include?(user.role)
  #   # ou
  # ["admin", "manager", "auditor", "financeiro"].include?(user.role)
  #   end

  #   # OU se ele pertencer ao alto escalão da empresa (admin, manager, auditor)
  # record.user_id == user.id || ["admin", "manager", "auditor"].include?(user.role)
end
