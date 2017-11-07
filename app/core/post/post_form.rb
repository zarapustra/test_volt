class Post::PostForm < Rectify::Form
  attribute :title, String
  attribute :body, String
  attribute :published_at, DateTime
  attribute :user, User

  validates :title, :body, :user, :presence => true

  def before_validation
    assign_time
  end

  private

  def assign_time
    self.published_at ||= Time.current
  end
end
