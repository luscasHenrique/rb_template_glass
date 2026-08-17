class ProfilePolicy < ApplicationPolicy
  # "user" é o usuário logado (Quem está acessando)
  # "record" é o perfil requisitado (O dado que está no banco)

  def index?
    # REGRA: Acesso exclusivo para o futuro Painel de Administração e API Gerencial.
    # Usuários comuns nunca podem ver uma lista de todos os perfis.
    [ "admin", "manager", "master" ].include?(user.role)
  end

  def show?
    # REGRA: O dono do perfil pode ver seus próprios dados (útil para a API),
    # OU a Diretoria pode acessar a ficha dele pelo Painel Admin.
    record.user_id == user.id || [ "admin", "manager", "auditor", "master" ].include?(user.role)
  end

  def create?
    # REGRA FECHADA: Ninguém cria um "perfil solto" no painel Admin. 
    # O perfil nasce obrigatoriamente junto com a criação de um User (via Devise).
    false
  end

  def new?
    create?
  end

  def update?
    # REGRA: O dono altera seus dados via Devise/API, 
    # e o Administrador tem o poder de alterar via Painel de Controle.
    record.user_id == user.id || [ "admin", "master" ].include?(user.role)
  end

  def destroy?
    # REGRA: Apenas cargos de altíssimo risco (Master/Admin) podem apagar fisicamente um perfil.
    [ "admin", "master" ].include?(user.role)
  end
end