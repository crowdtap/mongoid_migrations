Feature: User Migrations

  In order to create a great application
  I should be able to use my migrations

  Background:
    Given I generate a Rails application with mongo migrations

  Scenario: Empty Database
    Given I have 2 pending migrations
    When I run "bundle exec rake mongo:migrate:up"
    Then my database should have 0 pending migrations
    And I should see "TestMigration0: migrated"
    And I should see "TestMigration1: migrated"
    And the migrations collection should have a "test_migration_1" document
    And the migrations collection should have a "test_migration_2" document

    When I run "bundle exec rake mongo:migrate:down"
    Then my database should have 1 pending migrations
    And the migrations collection should have "test_migration_1" document
    And the migrations collection should not have "test_migration_1" document
