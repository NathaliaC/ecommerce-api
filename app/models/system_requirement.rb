class SystemRequirement < ApplicationRecord
  has_many :games, dependent: :restrict_with_error
  validates :name, :operational_system, :storage, :processor, :memory, :video_board, presence: true
  validates :name, uniqueness: { case_sensitive: false }
end
