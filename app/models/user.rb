class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :profile, dependent: :destroy
  
  # LGPD: Relação com os contratos que o usuário já assinou
  has_many :user_agreements, dependent: :destroy

  enum :role, { user: 0, admin: 1, manager: 2, auditor: 3, financeiro: 4, master: 5 }, default: :user

  # Permite que o User receba e salve dados do Profile no mesmo formulário
  accepts_nested_attributes_for :profile, update_only: true

  # Gatilho para popular a árvore de dados imediatamente após o cadastro
  after_create :build_associations

  # REGRA DE NEGÓCIO (LGPD): Verifica se o usuário aceitou o termo ativo no momento
  def accepted_current_term?
    current_term = PolicyTerm.find_by(active: true)
    
    # Se a Diretoria ainda não ativou nenhum termo no sistema, libera o acesso livremente
    return true unless current_term 
    
    # Se existe um termo ativo, procura na tabela de Aceites se este usuário assinou este ID específico
    user_agreements.exists?(policy_term_id: current_term.id)
  end

  private

  def build_associations
    # Cria o perfil e, em cascata, já cria o endereço ligado a ele
    p = create_profile
    p.create_address
  end
end