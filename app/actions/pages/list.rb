class Pages::List < Action

  def initialize(payload)
    @payload = payload
  end

  def call
    Page.arrange_as_array(order: :position)
  end
end
