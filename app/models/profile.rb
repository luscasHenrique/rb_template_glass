class Profile < ApplicationRecord
  has_paper_trail
  belongs_to :user
  has_one :address, as: :addressable, dependent: :destroy
accepts_nested_attributes_for :address, allow_destroy: true

# =====================================================================
  # 1. VALIDAÇÕES DE INTEGRIDADE DE DADOS
  # =====================================================================
  # O allow_blank permite que o usuário não preencha, caso não seja obrigatório. 
  # Se for obrigatório, adicione `presence: true`.
  validates :phone, length: { minimum: 10, maximum: 11 }, allow_blank: true
  validates :first_name, :last_name, presence: true
  # =====================================================================
  # 2. CALLBACKS (SANITIZAÇÃO)
  # =====================================================================
  
  # Antes de rodar a validação acima e antes de salvar no banco, ele limpa a sujeira do Frontend
  before_validation :sanitize_phone_number

  private

  def sanitize_phone_number
    # Pega o que veio da máscara do frontend ex: "(11) 99999-9999"
    # E usa Regex (\D) para remover absolutamente tudo que não for número -> "11999999999"
    self.phone = phone.to_s.gsub(/\D/, '') if phone.present?
  end
end
