class Pages::Find < Action

  def initialize(payload)
    @payload = payload
  end

  def call
    Page.includes(sections: [ :blocks ]).find(@payload[:id])
  end

end
