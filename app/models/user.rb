class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  has_one :profile, dependent: :destroy
  enum :role, { user: 0, admin: 1, manager: 2 }, default: :user

  # Permite que o User receba e salve dados do Profile no mesmo formulário
  accepts_nested_attributes_for :profile, update_only: true

  # Gatilho para popular a árvore de dados imediatamente após o cadastro
  after_create :build_associations

  private

  def build_associations
    # Cria o perfil e, em cascata, já cria o endereço ligado a ele
    p = create_profile
    p.create_address
  end
end