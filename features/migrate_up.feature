Feature: User Migrations

  In order to create a great application
  I should be able to use my migrations

  Background:
    Given I generate a Rails application with mongo migrations

  Scenario: Empty Database
    When I run "script/generate mongo_migration test_migration_1"
    And I run "script/generate mongo_migration test_migration_2"
    And I run "bundle exec rake mongo:migrate"
    Then I should see "TestMigration0: migrated"
    And I should see "TestMigration1: migrated"
    And the migrations collection should have a "test_migration_1" document
    And the migrations collection should have a "test_migration_2" document

    When I run "bundle exec rake mongo:migrate:down"
    Then the migrations collection should have a "test_migration_1" document
    And the migrations collection should not have a "test_migration_1" document
