class User < ApplicationRecord
  # =====================================================================
  # 1. ASSOCIAÇÕES, AUDITORIA E COMPLIANCE
  # =====================================================================
  has_paper_trail

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :profile, dependent: :destroy
  has_many :user_agreements, dependent: :destroy

  # MÓDULO DE AGENDA E PRODUTIVIDADE
  has_many :created_schedule_items, class_name: "ScheduleItem", foreign_key: "creator_id", dependent: :destroy
  has_many :schedule_guests, dependent: :destroy
  has_many :appointments, through: :schedule_guests, source: :schedule_item

  enum :role, { user: 0, admin: 1, manager: 2, auditor: 3, financeiro: 4, master: 5 }, default: :user
  accepts_nested_attributes_for :profile, update_only: true

  # Gatilhos de criação
  before_create :set_default_active_status # <--- GATILHO DE INTEGRIDADE ADICIONADO AQUI
  after_create :build_associations

  # =====================================================================
  # 2. STATUS DA CONTA (Soft Delete no Devise)
  # =====================================================================
  def active_for_authentication?
    super && self.active != false
  end

  def inactive_message
    self.active != false ? super : :account_inactive
  end

  # =====================================================================
  # 3. REGRAS DE NEGÓCIO (LGPD)
  # =====================================================================
  def accepted_current_term?
    current_term = PolicyTerm.find_by(active: true)
    return true unless current_term 
    user_agreements.exists?(policy_term_id: current_term.id)
  end

  private

  # =====================================================================
  # 4. GATILHOS DE BANCO DE DADOS (Callbacks)
  # =====================================================================
  
 def set_default_active_status
    # REGRA DE NEGÓCIO (Zero Trust): Novos cadastros aguardam aprovação da gestão.
    self.active = false if self.active.nil?
  end

  def build_associations
    if self.profile.present?
      self.profile.create_address unless self.profile.address.present?
    else
      p = self.create_profile(first_name: "Usuário", last_name: "Novo")
      p.create_address
    end
  end
end