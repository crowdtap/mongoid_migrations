module MongoHelpers
  def drop_collections
    DB.collection_names.each do |collection|
      DB.drop_collection(collection)
    end
  end

  def migration_filenames
    Dir[File.join(RAILS_ROOT, 'db', 'mongo_migrate', '*.rb')]
  end

  def last_migration_filename
    migration_filenames.last
  end
end

World(MongoHelpers)
