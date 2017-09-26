class Post
  attr_reader :id, :title, :body, :author, :create_at

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
    insert_query = <<-SQL
      INSERT INTO posts (title, body, author, create_at) VALUES (?, ?, ?, ?)
    SQL

    connection.execute insert_query,
      title,
      body,
      author,
      Date.current.to_s
  end

  def initialize(attributes={})
    @id = attributes['id']
    @title = attributes['title']
    @author = attributes['author']
    @body = attributes['body']
    @create_at = attributes['create_at']
  end

  private

  def connection
    self.class.connection
  end
end