# frozen_string_literal: true

# cada produto vendido na loja e classificado dentro de uma
# categoria e as informacoes dessas categorias sao armazenadas aqui
class Category < ApplicationRecord
  include NameSearchable
  include Paginatable

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  has_many :product_categories, dependent: :destroy
  has_many :products, through: :product_categories
end
