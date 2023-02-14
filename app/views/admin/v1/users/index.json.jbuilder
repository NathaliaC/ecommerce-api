# frozen_string_literal: true

json.users do
  json.array! @users, :id, :name, :email, :profile
end
