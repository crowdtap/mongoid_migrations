Feature: Migration Generation
  In order to create a great application
  I should be able to generate a new migration file
  Background:
    Given I have a new rails app

  Scenario: Generate a migration
    When I generate a migration
    Then I should have a new migration file
    And the migration should have proper content