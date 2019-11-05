class Posts::Create < Action

  def initialize(payload)
    @payload = payload
  end

  def call
    Post.create @payload
  end

end
