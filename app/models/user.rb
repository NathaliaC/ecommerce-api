# frozen_string_literal: true

# aqui ficaram armazenadas as informacoes dos usuarios
# que iram utilizar o sistema
class User < ActiveRecord::Base
  include NameSearchable
  include Paginatable

  PROFILES = { admin: 0, client: 1 }.freeze
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  validates :name, :profile, presence: true
  enum profile: PROFILES
end
