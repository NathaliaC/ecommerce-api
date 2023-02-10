# frozen_string_literal: true

module Paginatable
  extend ActiveSupport::Concern

  MAX_PER_PAGE = 10
  DEFAULT_PAGE = 1

  included do
    scope :paginate, lambda { |page, length|
      page = page.present? && page.positive? ? page : DEFAULT_PAGE
      length = length.present? && page.positive? ? length : MAX_PER_PAGE
      starts_at = (page - 1) * length
      limit(length).offset(starts_at)
    }
  end
end
