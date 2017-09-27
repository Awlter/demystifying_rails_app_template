class Post
  attr_reader :id, :title, :body, :author, :create_at, :errors

  def self.all
    post_hashes = connection.execute("SELECT * FROM posts")
    post_hashes.map do |post_hash|
      Post.new(post_hash)
    end
  end

  def self.find(id)
    find_query = "SELECT * FROM posts WHERE id = ?"
    post_hash = connection.execute(find_query, id).first

    Post.new(post_hash)
  end

  def save
    return false unless valid?

    if new_record?
      insert
    else
      update
    end
  end

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

  def destroy
    connection.execute("DELETE FROM posts WHERE id = ?", id)
  end

  def comments
    comment_hashes = connection.execute("SELECT * FROM comments WHERE post_id = ?", id)
    comment_hashes.map do |comment_hash|
      Comment.new(comment_hash)
    end
  end

  def create_comment(attributes)
    comment = Comment.new(attributes.merge!('post_id' => id))
    comment.save
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

  def self.connection
    db_connection = SQLite3::Database.new 'db/development.sqlite3'
    db_connection.results_as_hash = true
    db_connection
  end

  def connection
    self.class.connection
  end

  def new_record?
    id.nil?
  end

  def valid?
    @errors['title'] = "can't be blank" if title.blank?
    @errors['author'] = "can't be blank" if author.blank?
    @errors['body'] = "can't be blank" if body.blank?

    @errors.empty?
  end
end