class Address < ApplicationRecord
  belongs_to :addressable, polymorphic: true

  validates :zip_code, length: { is: 8 }, allow_blank: true
  before_validation :sanitize_zip_code

  private
  def sanitize_zip_code
    self.zip_code = zip_code.to_s.gsub(/\D/, '') if zip_code.present?
  end
end
