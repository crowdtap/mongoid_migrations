Feature: Migration Generation

  In order to create a great application
  I should be able to generate a new migration file

  Background:
    Given I generate a Rails application with mongo migrations

  Scenario: Display usage screen
    When I run the mongo migration generator with ""
    And I should see mongo_migration's USAGE

  Scenario: Generate a migration
    When I run "bundle exec script/generate mongo_migration test_migration"
    Then I should have a new migration file
    And the generated migration should contain "TestMigration"

  Scenario: Generate a migration with the same name
    When I run "bundle exec script/generate mongo_migration test_migration"
    And  I run "bundle exec script/generate mongo_migration test_migration"
    Then I should see "Another migration is already named test_migration"
