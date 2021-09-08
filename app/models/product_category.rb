# frozen_string_literal: true

# um produto pode pertencer a varias categorias assim como
# uma categoria pode estar associada a varios produtos
class ProductCategory < ApplicationRecord
  belongs_to :product
  belongs_to :category
end
