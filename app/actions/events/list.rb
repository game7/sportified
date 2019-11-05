require 'chronic'

class Events::List < Action

    def initialize(payload)
      @payload = payload
    end
  
    def call
      date = Chronic.parse(@payload[:date])
      Event.after(date.beginning_of_month)
           .before(date.end_of_month)
           .includes(:location, taggings: :tag)
           .order(starts_on: :desc)
    end
  
  end
  