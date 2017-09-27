class Comment < BaseModel
  attr_reader :body, :author, :post_id, :created_at

  def insert
    insert_comment_query = <<-SQL
      INSERT INTO comments (body, author, post_id, created_at)
      VALUEs (?, ?, ?, ?)
    SQL

    connection.execute(insert_comment_query, body, author, post_id , Date.current.to_s)
  end

  def destroy
    connection.execute("DELETE FROM comments WHERE id = ?", id)
  end

  def post
    Post.find(post_id)
  end

  def initialize(attributes={})
    @id = attributes['id'] if new_record?
    @body = attributes['body']
    @author = attributes['author']
    @post_id = attributes['post_id']
    @created_at ||= attributes['created_at']

    @errors = {}
  end

  private

  def valid?
    @errors['body'] = "can't be blank" if body.blank?
    @errors['author'] = "can't be blank" if author.blank?

    @errors.empty?
  end
end