Feature: Migration Generation
  In order to create a great application
  I should be able to generate a new migration file
  Background:
    Given I have a new rails app

  Scenario: Display usage screen
    When I call generate without parameters
    Then I should see the usage help

  Scenario: Generate a migration
    When I generate a migration
    Then I should have a new migration file
    And the migration should have proper content

  Scenario: Generate a migration with the same name
    When I generate a migration
    And I generate a migration again
    Then I should see a message that the migration already exists
