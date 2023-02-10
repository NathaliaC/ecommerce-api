# frozen_string_literal: true

json.coupon do
  json.call(@coupon, :id, :code, :status, :discount_value, :due_date)
end
