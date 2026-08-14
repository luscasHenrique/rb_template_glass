class PolicyTerm < ApplicationRecord
  has_many :user_agreements, dependent: :restrict_with_error

  validates :version, :content, presence: true

  # Gatilho: Antes de salvar no banco, se este termo estiver sendo marcado como "Ativo", roda o método abaixo
  before_save :deactivate_other_terms, if: :active_changed_to_true?

  private

  def active_changed_to_true?
    active? && active_changed?
  end

  def deactivate_other_terms
    # Pega todos os outros termos (que não são este) e muda o 'active' para false
    PolicyTerm.where.not(id: id).update_all(active: false)
  end
end