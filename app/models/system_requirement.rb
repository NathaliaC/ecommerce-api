# frozen_string_literal: true

# um computador para executar um game precisa ter uma
# configuracao minima de sistema
class SystemRequirement < ApplicationRecord
  include NameSearchable
  include Paginatable

  has_many :games, dependent: :restrict_with_error
  validates :name, :operational_system, :storage, :processor, :memory, :video_board, presence: true
  validates :name, uniqueness: { case_sensitive: false }
end
