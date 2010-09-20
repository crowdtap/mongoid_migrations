Mongo migrations for Ruby on Rails
==================================

Install
-------

    ./script/plugin install git@github.com:crowdtap/mongo_migrations.git

Migration Generator
-------------------

    ./script/generate mongo_migration

for usage info.

    ./script/generate mongo_migration AddNewlyAddedFieldDefaultToExistingDocuments

It will create new directory db/mongo_migrate, and new migration files.
The plugin more or less follows the same formula as the regular ActiveRecord migration:
up and down methods that get executed on their respective up/down migrations.

Rake Tasks
----------

All rake tasks are grouped in the mongoid namespace:

rake mongoid:migrate       # Migrate the database through scripts in db/mongoid_migrate.
rake mongoid:migrate:down  # Runs the "down" for a given migration VERSION.
rake mongoid:migrate:redo  # Rollbacks the database one migration and re migrate up.
rake mongoid:migrate:up    # Runs the "up" for a given migration VERSION.
rake mongoid:rollback      # Rolls the schema back to the previous version.
rake mongoid:setup         # Migrate the database and initialize with the seed data
rake mongoid:version       # Retrieves the current schema version number

Authors
-------

Galin Yordanov <gyordanov@gmail.com>

