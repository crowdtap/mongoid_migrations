Mongoid/Rails migration support
====================
Galin Yordanov <gyordanov@gmail.com>
Verion 0.1 08 March, 2010

install as a plugin:
./script/plugin install git@github.com:crowdtap/mongoid_migrations.git
or git submodule:
git submodule add git@github.com:crowdtap/mongoid_migrations.git vendor/plugins/mongoid_migrations

The plugins includes a migration generator and couple rake task.

== Migration Generator
Run
  ./script/generate mongoid_migration
for usage info.
It will create new directory db/mongoid_migrate, and new migration files.
It follows the same formula as the regular ActiveRecord migration:
up and down methods that get executed on their respective up/down migrations.

== Rake Tasks
All rake tasks are grouped in the mongoid namespace:

rake mongoid:migrate                      # Migrate the database through scripts in db/mongoid_migrate.
rake mongoid:migrate:down                 # Runs the "down" for a given migration VERSION.
rake mongoid:migrate:redo                 # Rollbacks the database one migration and re migrate up.
rake mongoid:migrate:up                   # Runs the "up" for a given migration VERSION.
rake mongoid:rollback                     # Rolls the schema back to the previous version.
rake mongoid:setup                        # Migrate the database and initialize with the seed data
rake mongoid:version                      # Retrieves the current schema version number
