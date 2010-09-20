module MongoHelpers
  def drop_collections
    connection = Mongo::Connection.new
    db = connection.db("mongo_migration_db")

    db.collection_names.each do |collection|
      db.drop_collection(collection)
    end
  end

  def first_migration
    Dir[File.join(RAILS_ROOT, 'db', 'mongo_migrate', '*')].first
  end
end

World(MongoHelpers)
