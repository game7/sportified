require_dependency "rms/application_controller"

module Rms
  module Api
    class ItemsController < ApplicationController
      before_action :verify_admin

      def index
        render json: Rms::Item.all, adapter: :json
      end

      def show
        item = ::Rms::Item.includes(registrations: :forms ).find(params[:id]);
        render json: Rms::Api::Items::ShowSerializer.new(item), adapter: :json, key_transform: :camel_lower
      end

      def extract
        item = ::Rms::Item.includes(registrations: [:forms, :variant, :user]).find(params[:id]);
        flattened = item.registrations.collect do |r|
          data = r.forms.collect{|form| form.data || {}}.reduce({}){|sum, data| sum.merge(data) }
          {
            id: r.id,
            item: r.item.title,
            variant: r.variant.title,
            first_name: r.first_name,
            last_name: r.last_name,
            email: r.email,
            birthdate: r.birthdate,
            confirmation_code: r.confirmation_code,
            payment_id: r.payment_id,
            created_at: r.created_at,
            updated_at: r.updated_at,
            price: r.price,
          }.merge(data)
        end
        keys = flattened.map(&:keys).flatten.uniq
        rows = flattened.map do |flat|
          keys.map{|key| flat[key]}
        end.unshift(keys)
        render json: rows
      end

    end
  end
end
