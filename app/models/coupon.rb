class Coupon < ApplicationRecord
  STATUS = { active: 1, inactive: 2 }.freeze
  validates :code, :status, :due_date, :discount_value, presence: true
  validates :code, uniqueness: { case_sensitive: false }
  validates :discount_value, numericality: { greater_than: 0 }
  enum status: STATUS
end
