class Product < ApplicationRecord
  belongs_to :productable, polymorphic: true
  validates :name, :description, :price, presence: true
  validates :name, uniqueness: { case_sensitive: false }
  validates :price, numericality: { greater_than: 0 }
end
