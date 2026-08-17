class Admin::UserPolicy < ApplicationPolicy
  def index?
    # Apenas usuários com role de master ou admin podem ver o menu e acessar a listagem
    ["master", "admin"].include?(user.role)
  end

  def edit?
    index?
  end

  def update?
    index?
  end

  def audit_logs?
    # Apenas master ou auditor para ver a caixa preta
    ["master", "admin", "auditor"].include?(user.role)
  end
end