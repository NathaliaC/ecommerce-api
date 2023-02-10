# frozen_string_literal: true

json.system_requirement do
  json.call(@system_requirement, :id, :name, :operational_system, :storage, :processor, :memory, :video_board)
end
