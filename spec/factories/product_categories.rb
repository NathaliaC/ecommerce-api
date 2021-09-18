# frozen_string_literal: true

FactoryBot.define do
  factory :product_category do
    product
    category
  end
end
