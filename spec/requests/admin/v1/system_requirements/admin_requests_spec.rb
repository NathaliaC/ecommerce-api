# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::V1::SystemRequirements as :admin', type: :request do
  let(:user) { create(:user) }
  let(:fields) { %i[id name operational_system storage processor memory video_board] }
  let(:response_errors) { body_json['errors']['fields'] }

  context 'GET /system_requirements' do
    let(:url) { '/admin/v1/system_requirements' }
    let!(:system_requirements) { create_list(:system_requirement, 5) }
    let(:do_request) { get url, headers: auth_header(user) }

    it 'return all System Requiriments' do
      do_request
      expect(body_json['system_requirements']).to contain_exactly(*system_requirements.as_json(only: fields))
    end

    it 'returns success status' do
      do_request
      expect(response).to have_http_status(:ok)
    end
  end

  context 'POST /system_requirements' do
    let(:url) { '/admin/v1/system_requirements' }

    context 'with valid params' do
      let(:system_requirement_params) do
        { system_requirement: attributes_for(:system_requirement) }.to_json
      end
      let(:do_request) { post url, headers: auth_header(user), params: system_requirement_params }

      it 'adds a new SystemRequirement ' do
        expect do
          do_request
        end.to change(SystemRequirement, :count).by(1)
      end

      it 'return last added SystemRequirement' do
        do_request
        expected_system_requirement = SystemRequirement.last.as_json(only: fields)
        expect(body_json['system_requirement']).to eq(expected_system_requirement)
      end

      it 'returns success status' do
        do_request
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid params' do
      let(:system_requirement_invalid_params) do
        { system_requirement: attributes_for(
          :system_requirement,
          name: nil,
          operational_system: nil,
          storage: nil,
          processor: nil,
          memory: nil,
          video_board: nil
        ) }.to_json
      end
      let(:do_request) { post url, headers: auth_header(user), params: system_requirement_invalid_params }

      it 'does not add a new SystemRequirement' do
        expect do
          do_request
        end.to_not change(SystemRequirement, :count)
      end

      it 'returns error message' do
        do_request
        expect(response_errors).to have_key('name')
        expect(response_errors).to have_key('operational_system')
        expect(response_errors).to have_key('storage')
        expect(response_errors).to have_key('processor')
        expect(response_errors).to have_key('memory')
        expect(response_errors).to have_key('video_board')
      end

      it 'returns unprocessable_entity status' do
        do_request
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  context 'PATCH /system_requirements/:id' do
    let(:system_requirement) { create(:system_requirement) }
    let(:url) { "/admin/v1/system_requirements/#{system_requirement.id}" }

    context 'with valid params' do
      let(:new_name) { 'My new system_requirement' }
      let(:system_requirement_params) { { system_requirement: { name: new_name } }.to_json }
      let(:do_request) { patch url, headers: auth_header(user), params: system_requirement_params }

      it 'updates System Requirement' do
        do_request
        system_requirement.reload
        expect(system_requirement.name).to eq(new_name)
      end

      it 'return updated system requirement' do
        do_request
        system_requirement.reload
        expected_system_requirement = system_requirement.as_json(only: fields)
        expect(body_json['system_requirement']).to eq(expected_system_requirement)
      end

      it 'return success status' do
        do_request
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid params' do
      let(:system_requirement_invalid_params) do
        { system_requirement: attributes_for(
          :system_requirement,
          name: nil,
          operational_system: nil,
          storage: nil,
          processor: nil,
          memory: nil,
          video_board: nil
        ) }
      end
      let(:system_requirement_new) { create(:system_requirement, name: 'Basic II') }
      let(:do_request) do
        patch url, headers: auth_header(user), params: system_requirement_invalid_params.to_json
      end

      it 'does not update System Requirement' do
        old_name = system_requirement.name
        old_operational_system = system_requirement.operational_system
        old_storage = system_requirement.storage
        old_processor = system_requirement.processor
        old_memory = system_requirement.memory
        old_video_board = system_requirement.video_board
        do_request
        system_requirement.reload
        expect(system_requirement.name).to eq old_name
        expect(system_requirement.operational_system).to eq old_operational_system
        expect(system_requirement.storage).to eq old_storage
        expect(system_requirement.processor).to eq old_processor
        expect(system_requirement.memory).to eq old_memory
        expect(system_requirement.video_board).to eq old_video_board
      end

      it 'returns error message' do
        expected_blank_error = I18n.t('errors.messages.blank')
        do_request
        expect(response_errors).to have_key('name')
        expect(response_errors['name']).to eq([expected_blank_error])
        expect(response_errors).to have_key('operational_system')
        expect(response_errors['operational_system']).to eq([expected_blank_error])
        expect(response_errors).to have_key('storage')
        expect(response_errors['storage']).to eq([expected_blank_error])
        expect(response_errors).to have_key('processor')
        expect(response_errors['processor']).to eq([expected_blank_error])
        expect(response_errors).to have_key('memory')
        expect(response_errors['memory']).to eq([expected_blank_error])
        expect(response_errors).to have_key('video_board')
        expect(response_errors['video_board']).to eq([expected_blank_error])
      end

      it 'returns error message when name in use' do
        existing_name = system_requirement_new.name
        system_requirement_invalid_params[:system_requirement][:name] = existing_name
        expected_taken_error = I18n.t('errors.messages.taken')

        do_request

        expect(response_errors).to have_key('name')
        expect(response_errors['name']).to eq([expected_taken_error])
      end

      it 'returns unprocessable_entity status' do
        do_request
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  context 'DELETE /system_requirements/:id' do
    let!(:system_requirement) { create(:system_requirement) }
    let(:url) { "/admin/v1/system_requirements/#{system_requirement.id}" }
    let(:do_request) { delete url, headers: auth_header(user) }

    context 'when has no associated products' do
      it 'removes System Requirements' do
        expect do
          do_request
        end.to change(SystemRequirement, :count).by(-1)
      end

      it 'returns success status' do
        do_request
        expect(response).to have_http_status(:no_content)
      end

      it 'does not return any body content' do
        do_request
        expect(body_json).to_not be_present
      end
    end

    context 'when has associated products' do
      let!(:game) { create(:game, system_requirement:) }

      it 'no removes System Requirements' do
        expect do
          do_request
        end.to_not change(SystemRequirement, :count)
      end

      it 'returns error message' do
        expected_base_error = 'Não é possível excluir o registro pois existem games dependentes'

        do_request
        expect(response_errors).to have_key('base')
        expect(response_errors['base']).to eq([expected_base_error])
      end

      it 'returns unprocessable_entity status' do
        do_request
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
