# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::V1::User as :admin', type: :request do
  let!(:login_user) { create(:user) }
  let(:fields) { %i[id name email profile] }
  let(:response_errors) { body_json['errors']['fields'] }

  context 'GET /users' do
    let(:url) { '/admin/v1/users' }
    let!(:users) { create_list(:user, 5) }
    let(:do_request) { get url, headers: auth_header(login_user) }

    it 'return all User' do
      do_request
      expect(body_json['users']).to contain_exactly(*users.as_json(only: fields))
    end

    it 'returns success status' do
      do_request
      expect(response).to have_http_status(:ok)
    end
  end

  context 'POST /users' do
    let(:url) { '/admin/v1/users' }

    context 'with valid params' do
      let(:user_params) { { user: attributes_for(:user) }.to_json }
      let(:do_request) { post url, headers: auth_header(login_user), params: user_params }

      it 'adds a new User ' do
        expect do
          do_request
        end.to change(User, :count).by(1)
      end

      it 'return last added User' do
        do_request
        expected_user = User.last.as_json(only: fields)
        expect(body_json['user']).to eq(expected_user)
      end

      it 'returns success status' do
        do_request
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid params' do
      let(:user_invalid_params) do
        { user: attributes_for(
          :user,
          name: nil,
          email: nil,
          profile: nil
        ) }.to_json
      end
      let(:do_request) { post url, headers: auth_header(login_user), params: user_invalid_params }

      it 'does not add a new User' do
        expect do
          do_request
        end.to_not change(User, :count)
      end

      it 'returns error message' do
        do_request
        expect(response_errors).to have_key('name')
        expect(response_errors).to have_key('email')
        expect(response_errors).to have_key('profile')
      end

      it 'returns unprocessable_entity status' do
        do_request
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  context 'PATCH /users/:id' do
    let(:user) { create(:user) }
    let(:url) { "/admin/v1/users/#{user.id}" }

    context 'with valid params' do
      let(:new_name) { Faker::Name.name }
      let(:user_params) { { user: { name: new_name } }.to_json }
      let(:do_request) { patch url, headers: auth_header(login_user), params: user_params }

      it 'updates User' do
        do_request
        user.reload
        expect(user.name).to eq(new_name)
      end

      it 'return updated user' do
        do_request
        user.reload
        expected_user = user.as_json(only: fields)
        expect(body_json['user']).to eq(expected_user)
      end

      it 'return success status' do
        do_request
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid params' do
      let(:user_invalid_params) do
        { user: attributes_for(
          :user,
          name: nil,
          email: nil,
          profile: nil
        ) }
      end
      let(:do_request) do
        patch url, headers: auth_header(login_user), params: user_invalid_params.to_json
      end

      it 'does not update User' do
        old_attributes = user.attributes
        do_request
        user.reload
        expect(user.attributes).to eq(old_attributes)
      end

      it 'returns error messages for missing required fields' do
        expected_blank_error = I18n.t('errors.messages.blank')
        do_request

        required_fields = %w[name email profile]
        required_fields.each do |field|
          expect(response_errors).to have_key(field)
          expect(response_errors[field]).to eq([expected_blank_error])
        end
      end

      it 'returns 422 status' do
        do_request
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  context 'DELETE /users/:id' do
    let!(:user) { create(:user) }
    let(:url) { "/admin/v1/users/#{user.id}" }
    let(:do_request) { delete url, headers: auth_header(login_user) }

    it 'removes User' do
      expect do
        do_request
      end.to change(User, :count).by(-1)
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
end
