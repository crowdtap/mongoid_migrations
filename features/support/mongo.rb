module MongoHelpers
  def drop_collections
    connection = Mongo::Connection.new
    db = connection.db("mongoid_migrations_test_database")

    db.collection_names.each do |collection|
      db.drop_collection(collection)
    end
  end

  def first_migration
    Dir[File.join(RAILS_ROOT, 'db', 'mongoid_migrate', '*')].first
  end
end

World(MongoHelpers)
