class SystemRequirement < ApplicationRecord
  validates :name, :operational_system, :storage, :processor, :memory, :video_board, presence: true
  validates :name, uniqueness: { case_sensitive: false }
end
