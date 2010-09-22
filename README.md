Mongo migrations for Ruby on Rails
==================================

Install
-------

Install the plugin:

    ./script/plugin install git@github.com:crowdtap/mongo_migrations.git

Configure Mongo::Migration in config/initializers/mongo_migration.rb:

    Mongo::Migration.configure do |config|
      mongoid_config = YAML::load('/config/mongoid.yml')[Rails.env].symbolize_keys

      config.db_name = mongoid_config[:database]
      config.db_host = mongoid_config[:host]
      config.db_port = mongoid_config[:port]
    end

This example re-uses the Mongoid config but write it to fit your needs no matter
the Object-Document Mapper you're using.

db_name is required. The defaults for the others are:

    db_host = 'localhost'
    db_port = 27017

Migration Generator
-------------------

    ./script/generate mongo_migration

for usage info.

    ./script/generate mongo_migration AddNewlyAddedFieldDefaultToExistingDocuments

It will create a migration file in db/mongo_migrate.

The plugin more or less follows the same formula as the regular ActiveRecord migration:
up and down methods that get executed on their respective up/down migrations.

Rake Tasks
----------

All rake tasks are grouped in the mongo namespace:

rake mongo:migrate       # Migrate the database through scripts in db/mongo_migrate.
rake mongo:migrate:down  # Runs the "down" for a given migration VERSION.
rake mongo:migrate:redo  # Rollbacks the database one migration and re migrate up.
rake mongo:migrate:up    # Runs the "up" for a given migration VERSION.
rake mongo:rollback      # Rolls the schema back to the previous version.

Authors
-------

Galin Yordanov <gyordanov@gmail.com>

