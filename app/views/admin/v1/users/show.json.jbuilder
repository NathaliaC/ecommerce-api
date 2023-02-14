# frozen_string_literal: true

json.user do
  json.call(@user, :id, :name, :email, :profile)
end
