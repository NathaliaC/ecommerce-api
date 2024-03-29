# frozen_string_literal: true

FactoryBot.define do
  factory :game do
    mode { %i[pvp pve both].sample }
    release_date { '2020-11-21 23:21:24' }
    developer { Faker::Company.name }
    system_requirement
  end
end
