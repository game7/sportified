class Tags::List < Action

    def initialize(payload)
      @payload = payload
    end
  
    def call
      ActsAsTaggableOn::Tag.all.order(:id)
    end
  
  end
  