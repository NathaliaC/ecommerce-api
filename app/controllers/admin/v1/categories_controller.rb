# frozen_string_literal: true

module Admin
  module V1
    # controlador de categoria
    class CategoriesController < ApiController
      before_action :load_category, only: %i[show update destroy]

      def index
        @categories = Category.all
      end

      def create
        @category = Category.new
        @category.attributes = category_params
        save_category!
      end

      def show; end

      def update
        @category.attributes = category_params
        save_category!
      end

      def destroy
        @category.destroy!
      rescue StandardError
        render_error(fields: @category.errors.messages)
      end

      private

      def category_params
        return {} unless params.key?(:category)

        params.require(:category).permit(:id, :name)
      end

      def save_category!
        @category.save!
        render :show
      rescue StandardError
        render_error(fields: @category.errors.messages)
      end

      def load_category
        @category = Category.find(params[:id])
      end
    end
  end
end
