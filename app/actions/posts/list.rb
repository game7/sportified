class Posts::List < Action

  def initialize(payload)
    @payload = payload
  end

  def call
    Post.all.newest_first.includes(:tags)
  end
end
