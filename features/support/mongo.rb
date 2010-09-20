module MongoHelpers
  def db
    connection = Mongo::Connection.new
    connection.db("mongo_migration_db")
  end

  def drop_collections
    db.collection_names.each do |collection|
      db.drop_collection(collection)
    end
  end

  def first_migration
    Dir[File.join(RAILS_ROOT, 'db', 'mongo_migrate', '*')].first
  end
end

World(MongoHelpers)
