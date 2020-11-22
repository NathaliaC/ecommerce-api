class Product < ApplicationRecord
  belongs_to :productable, polymorphic: true
  validates :name, :description, :price, presence: true
  validates :name, uniqueness: { case_sensitive: false }
  validates :price, numericality: { greater_than: 0 }
  has_many :product_categories, dependent: :destroy
  has_many :categories, through: :product_categories
end
