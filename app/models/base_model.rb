class BaseModel
  attr_reader :id, :errors

  def self.table_name
    to_s.pluralize.downcase
  end

  def self.all
    record_hashes = connection.execute("SELECT * FROM #{table_name}")
    record_hashes.map do |record_hash|
      new(record_hash)
    end
  end

  def self.find(id)
    find_query = "SELECT * FROM #{table_name} WHERE id = ?"
    new(connection.execute(find_query, id).first)
  end

  def destroy
    connection.execute("DELETE FROM #{self.class.table_name} WHERE id = ?", id)
  end

  def save
    return false unless valid?

    if new_record?
      insert
    else
      update
    end
  end

  def new_record?
    id.nil?
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
end