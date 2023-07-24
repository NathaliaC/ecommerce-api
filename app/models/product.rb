# frozen_string_literal: true

# a loja vende produtos e as informacoes desses produtos
# seram armazenadas nesse modelo
class Product < ApplicationRecord
  include NameSearchable
  include Paginatable

  belongs_to :productable, polymorphic: true
  validates :name, :description, :price, :image, presence: true
  validates :name, uniqueness: { case_sensitive: false }
  validates :price, numericality: { greater_than: 0 }
  has_many :product_categories, dependent: :destroy
  has_many :categories, through: :product_categories
  has_one_attached :image
  validates :status, presence: true

  enum status: { available: 1, unavailable: 2 }
end
