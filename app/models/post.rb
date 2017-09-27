class Post < BaseModel
  attr_reader :title, :body, :author, :create_at

  def insert
    insert_query = <<-SQL
      INSERT INTO posts (title, body, author, create_at) VALUES (?, ?, ?, ?)
    SQL

    connection.execute insert_query,
      title,
      body,
      author,
      Date.current.to_s
  end

  def update
    update_query = <<-SQL
      UPDATE posts
      SET   title = ?,
            body = ?,
            author = ?
      WHERE id = ?
    SQL

    connection.execute update_query,
      title, body, author, id
  end

  def comments
    comment_hashes = connection.execute("SELECT * FROM comments WHERE post_id = ?", id)
    comment_hashes.map do |comment_hash|
      Comment.new(comment_hash)
    end
  end

  def build_comment(attributes)
    Comment.new(attributes.merge!('post_id' => id))
  end

  def create_comment(attributes)
    comment = build_comment(attributes)
    comment.save
  end

  def delete_comment(comment_id)
    comment = Comment.find(comment_id)
    comment.destroy
  end

  def set_attributes(attributes)
    @id = attributes['id'] if new_record?
    @title = attributes['title']
    @author = attributes['author']
    @body = attributes['body']
    @create_at ||= attributes['create_at']
  end

  def initialize(attributes={})
    set_attributes(attributes)
    @errors = {}
  end

  private

  def valid?
    @errors['title'] = "can't be blank" if title.blank?
    @errors['author'] = "can't be blank" if author.blank?
    @errors['body'] = "can't be blank" if body.blank?

    @errors.empty?
  end
end