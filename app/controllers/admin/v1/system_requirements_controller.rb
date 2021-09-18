# frozen_string_literal: true

module Admin
  module V1
    # controlador dos requisitos do sistema
    class SystemRequirementsController < ApiController
      def index
        @system_requirements = SystemRequirement.all
      end
    end
  end
end
