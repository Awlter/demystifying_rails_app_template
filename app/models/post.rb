class Post
  attr_reader :id, :title, :body, :author, :create_at

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

  def self.connection
    db_connection = SQLite3::Database.new 'db/development.sqlite3'
    db_connection.results_as_hash = true
    db_connection
  end

  def save
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

  def set_attributes(attributes)
    @id = attributes['id'] if new_record?
    @title = attributes['title']
    @author = attributes['author']
    @body = attributes['body']
    @create_at ||= attributes['create_at']
  end

  def initialize(attributes={})
    set_attributes(attributes)
  end

  private

  def new_record?
    id.nil?
  end

  def connection
    self.class.connection
  end
end