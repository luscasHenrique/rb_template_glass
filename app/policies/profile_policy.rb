class ProfilePolicy < ApplicationPolicy
  # "user" é o usuário logado (Quem está acessando)
  # "record" é o perfil requisitado (O dado que está no banco)

  def show?
    # REGRA: O usuário só pode ver a tela de detalhes se for o DONO do perfil
    # OU se ele pertencer ao alto escalão da empresa (admin, manager, auditor)
    record.user_id == user.id || ["admin", "manager", "auditor"].include?(user.role)
  end

  def update?
    # REGRA: Só pode editar se for o DONO do perfil OU se for um admin
    record.user_id == user.id || user.admin?
  end

  def destroy?
    # REGRA: Apenas o Administrador Master pode deletar perfis
    user.admin?
  end
end