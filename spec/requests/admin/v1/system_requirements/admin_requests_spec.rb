# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::V1::SystemRequirements as :admin', type: :request do
  let(:user) { create(:user) }

  context 'GET /system_requirements' do
    let(:url) { '/admin/v1/system_requirements' }
    let!(:system_requirements) { create_list(:system_requirement, 5) }
    let(:fields) { %i[id name operational_system storage processor memory video_board] }

    it 'return all System Requiriments' do
      get url, headers: auth_header(user)
      expect(body_json['system_requirements']).to contain_exactly(*system_requirements.as_json(only: fields))
    end

    it 'returns success status' do
      get url, headers: auth_header(user)
      expect(response).to have_http_status(:ok)
    end
  end

  context 'POST /system_requirements' do
    let(:url) { '/admin/v1/system_requirements' }
    let(:fields) { %i[id name operational_system storage processor memory video_board] }

    context 'with valid params' do
      let(:system_requirement_params) { { system_requirement: attributes_for(:system_requirement) }.to_json }

      it 'adds a new SystemRequirement ' do
        expect do
          post url, headers: auth_header(user), params: system_requirement_params
        end.to change(SystemRequirement, :count).by(1)
      end

      it 'return last added SystemRequirement' do
        post url, headers: auth_header(user), params: system_requirement_params
        expected_system_requirement = SystemRequirement.last.as_json(only: fields)
        expect(body_json['system_requirement']).to eq expected_system_requirement
      end

      it 'returns success status' do
        post url, headers: auth_header(user), params: system_requirement_params
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

      it 'does not add a new SystemRequirement' do
        expect do
          post url, headers: auth_header(user), params: system_requirement_invalid_params
        end.to_not change(SystemRequirement, :count)
      end

      it 'returns error message' do
        post url, headers: auth_header(user), params: system_requirement_invalid_params
        expect(body_json['errors']['fields']).to have_key('name')
        expect(body_json['errors']['fields']).to have_key('operational_system')
        expect(body_json['errors']['fields']).to have_key('storage')
        expect(body_json['errors']['fields']).to have_key('processor')
        expect(body_json['errors']['fields']).to have_key('memory')
        expect(body_json['errors']['fields']).to have_key('video_board')
      end

      it 'returns unprocessable_entity status' do
        post url, headers: auth_header(user), params: system_requirement_invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  # contexto: trazer a lista de requisitos do sistema
  # cria a variavel url
  # cria a lista de requisitos do sistema no banco
  # trazer todos os requisitos do sistema cadastrado
  # verificar status de sucesso

  # contexto: criar um requisito de sistema
  # cria a variavel url
  # contexto: com parametros validos
  # mokar parametros
  # adiciona uma novo requisito de sistema
  # retorna o último requisito adicionado
  # retorna status de sucesso

  #	contexto: com parametros inválidos
  # mokar parametros inválidos
  # nao adiciona uma nova categoria
  # retorna uma mensagem de erro
  # retorna status de entidade não processada

  # contexto: atualizar um requisito de sistema
  # cria a variavl url
  # cria um objeto do tipo requisito do sistema
  # contexto:com parametros validos
  # moka parametro que será atualizado
  # mokar parametros
  # atualizar o requisito de sistema
  # retorna o requisito atualizado
  # retorna status de sucesso

  #	contexto:com parametros inválidos
  # mokar parametros inválidos
  # nao atualiza o requisito do sistema
  # retorna uma mensagem de erro
  # retorna status de entidade não processada

  #	contexto: apagar um requisito de sistema
  # cria objeto de requisito do sistema
  # cria a url
  # remove as categorias
  # retorna status de sucesso
  # nao retorna nada no corpo da requisicao
  # remove todos os produtos associados ao requisito do sistema
end
