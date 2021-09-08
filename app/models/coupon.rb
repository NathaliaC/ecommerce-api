# frozen_string_literal: true

# Quando uma compra e feita na loja e gerado
# um cupom associado ao produto
class Coupon < ApplicationRecord
  include Paginatable

  STATUS = { active: 1, inactive: 2 }.freeze
  validates :code, :status, :due_date, :discount_value, presence: true
  validates :code, uniqueness: { case_sensitive: false }
  validates :discount_value, numericality: { greater_than: 0 }
  validates :due_date, future_date: true
  enum status: STATUS
end
