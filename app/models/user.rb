class User < ApplicationRecord
  # =====================================================================
  # 1. AUDITORIA E COMPLIANCE
  # =====================================================================
  # Ativa o PaperTrail: Grava de forma imutável quem alterou, quando alterou e o que foi alterado.
  has_paper_trail

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

  # =====================================================================
  # 2. STATUS DA CONTA (Soft Delete no Devise)
  # =====================================================================
  
  # Sobrescreve o Devise: O usuário só consegue fazer login se a conta estiver ativa no banco de dados.
  def active_for_authentication?
    super && self.active != false
  end

  # Customiza a mensagem de erro do Devise para contas inativadas pelo Administrador.
  def inactive_message
    self.active != false ? super : :account_inactive
  end

  # =====================================================================
  # 3. REGRAS DE NEGÓCIO (LGPD)
  # =====================================================================
  
  # Verifica se o usuário aceitou o termo ativo no momento
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