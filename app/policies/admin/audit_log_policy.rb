class Admin::AuditLogPolicy < ApplicationPolicy
  def index?
    # Apenas o Master e o Auditor de Compliance têm a visão do "Olho de Deus" no sistema
    ["master", "admin", "auditor"].include?(user.role)
  end
end