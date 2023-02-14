# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::V1::Coupons as :admin', type: :request do
  let(:user) { create(:user) }
  let(:fields) { %i[id code status discount_value due_date] }
  let(:response_errors) { body_json['errors']['fields'] }

  context 'GET /coupons' do
    let(:url) { '/admin/v1/coupons' }
    let!(:coupons) { create_list(:coupon, 5) }
    let(:do_request) { get url, headers: auth_header(user) }

    it 'return all Coupons' do
      do_request
      expect(body_json['coupons']).to contain_exactly(*coupons.as_json(only: fields))
    end

    it 'returns success status' do
      do_request
      expect(response).to have_http_status(:ok)
    end
  end

  context 'POST /coupons' do
    let(:url) { '/admin/v1/coupons' }

    context 'with valid params' do
      let(:coupon_params) { { coupon: attributes_for(:coupon) }.to_json }
      let(:do_request) { post url, headers: auth_header(user), params: coupon_params }

      it 'adds a new Coupon ' do
        expect do
          do_request
        end.to change(Coupon, :count).by(1)
      end

      it 'return last added Coupon' do
        do_request
        expected_coupon = Coupon.last.as_json(only: fields)
        expect(body_json['coupon']).to eq(expected_coupon)
      end

      it 'returns success status' do
        do_request
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid params' do
      let(:coupon_invalid_params) do
        { coupon: attributes_for(
          :coupon,
          code: nil,
          status: nil,
          discount_value: nil,
          due_date: nil
        ) }.to_json
      end
      let(:do_request) { post url, headers: auth_header(user), params: coupon_invalid_params }

      it 'does not add a new Coupon' do
        expect do
          do_request
        end.to_not change(Coupon, :count)
      end

      it 'returns error message' do
        do_request
        expect(response_errors).to have_key('code')
        expect(response_errors).to have_key('status')
        expect(response_errors).to have_key('discount_value')
        expect(response_errors).to have_key('due_date')
      end

      it 'returns unprocessable_entity status' do
        do_request
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  context 'PATCH /coupons/:id' do
    let(:coupon) { create(:coupon) }
    let(:url) { "/admin/v1/coupons/#{coupon.id}" }

    context 'with valid params' do
      fake_new_code = Faker::Commerce.unique.promotion_code(digits: 4)
      let(:new_code) { fake_new_code }
      let(:coupon_params) { { coupon: { code: new_code } }.to_json }
      let(:do_request) { patch url, headers: auth_header(user), params: coupon_params }

      it 'updates Coupon' do
        do_request
        coupon.reload
        expect(coupon.code).to eq(new_code)
      end

      it 'return updated coupon' do
        do_request
        coupon.reload
        expected_coupon = coupon.as_json(only: fields)
        expect(body_json['coupon']).to eq(expected_coupon)
      end

      it 'return success status' do
        do_request
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid params' do
      let(:coupon_invalid_params) do
        { coupon: attributes_for(
          :coupon,
          code: nil,
          status: nil,
          discount_value: nil,
          due_date: nil
        ) }
      end
      let(:fake_code) { Faker::Commerce.unique.promotion_code(digits: 4) }
      let(:coupon_new) { create(:coupon, code: fake_code) }
      let(:do_request) do
        patch url, headers: auth_header(user), params: coupon_invalid_params.to_json
      end

      it 'does not update Coupon' do
        old_attributes = coupon.attributes
        do_request
        coupon.reload
        expect(coupon.due_date.to_i).to eq(old_attributes['due_date'].to_i)
        expect(coupon.attributes.except('due_date')).to eq(old_attributes.except('due_date'))
      end

      it 'returns error messages for missing required fields' do
        expected_blank_error = I18n.t('errors.messages.blank')
        expected_not_a_number_error = I18n.t('errors.messages.not_a_number')
        do_request

        required_fields = %w[code status discount_value due_date]
        required_fields.each do |field|
          expect(response_errors).to have_key(field)
          if field == 'discount_value'
            expect(response_errors[field]).to eq([expected_blank_error, expected_not_a_number_error])
          else
            expect(response_errors[field]).to eq([expected_blank_error])
          end
        end
      end

      it 'returns error message when code in use' do
        existing_code = coupon_new.code
        coupon_invalid_params[:coupon][:code] = existing_code
        expected_error_message = I18n.t('errors.messages.taken')
        do_request
        expect(response_errors['code']).to eq [expected_error_message]
      end

      it 'returns 422 status' do
        do_request
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  context 'DELETE /coupons/:id' do
    let!(:coupon) { create(:coupon) }
    let(:url) { "/admin/v1/coupons/#{coupon.id}" }
    let(:do_request) { delete url, headers: auth_header(user) }

    it 'removes Coupons' do
      expect do
        do_request
      end.to change(Coupon, :count).by(-1)
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
