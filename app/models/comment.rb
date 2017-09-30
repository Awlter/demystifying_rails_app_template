class Comment < ActiveRecord::Base
  belongs_to :post
  validates_presence_of :body, :author

  after_save :update_lasted_commented_on

  private

  def update_lasted_commented_on
    self.post.last_commented_on = self.created_at
  end
end