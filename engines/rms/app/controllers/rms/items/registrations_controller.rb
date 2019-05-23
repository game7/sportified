require_dependency "rms/application_controller"
require 'csv'

module Rms
  class Items::RegistrationsController < ApplicationController

    def index
      @item = Item.find(params[:item_id])
      @registrations = Registration.joins(:variant)
                                   .where(rms_variants: { item_id: params[:item_id] })
                                   .where.not(payment_id: nil)
                                   .includes(variant: [:item], forms: [])

      @columns = %w( street city state postal)

      @data = @registrations.map do |r|
        result = {
          id: r.id,
          player_name: r.last_name + ', ' + r.first_name,
          status: (r.payment_id.present?) ? 'completed' : 'pending'
        }
        data = r.forms[0].data || {}
        @columns.each do |col|
          field = "home_address-#{col}"
          result[col.to_sym] = data[field]
        end
        result
      end

      respond_to do |format|
        format.html
        format.csv do
          result = ::CSV.generate do |csv|
            csv << @data[0].keys
            @data.each{|row| csv << row.values }
          end
          send_data result, filename: "registrations-#{@item.title.parameterize}-#{Date.today}.csv"
        end
      end

    end
    
  end
end
