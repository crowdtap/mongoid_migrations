Feature: Migration Generation

  In order to create a great application
  I should be able to generate a new migration file

  Background:
    Given I generate a Rails application with mongo migrations

  Scenario: Display usage screen
    When I run the mongo migration generator with ""
    And I should see the usage help

  Scenario: Generate a migration
    When I run the mongo migration generator with "test_migration"
    Then I should have a new migration file
    And the migration should have proper content

  Scenario: Generate a migration with the same name
    When I run the mongo migration generator with "test_migration"
    And I run the mongo migration generator with "test_migration"
    Then I should see a message that the migration already exists
