class Game < ApplicationRecord
  MODES = { pvp: 1, pve: 2, both: 3 }.freeze
  belongs_to :system_requirement
  has_one :product, as: :productable
  validates :mode, :release_date, :developer, presence: true
  enum mode: MODES
end
