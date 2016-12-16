require_dependency "rms/application_controller"

module Rms
  class DashboardController < ApplicationController

    def index
      items = Item.all.order(:title)
      render locals: {
        items: items,
        from_date: from_date
      }
    end

    private

    def from_date
      case params[:period]
      when 'month'
        Date.today.at_beginning_of_month
      when 'week'
        Date.today.at_beginning_of_week
      when 'day'
        Date.today
      else
        Date.parse('2000-01-01')
      end
    end

  end
end
