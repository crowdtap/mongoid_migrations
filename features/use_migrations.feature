Feature: User Migrations
  In order to create a great application
  I should be able to use my migrations

  Background:
    Given I have a new rails app

  Scenario: Empty Database
    Given I have 2 pending migrations
    When I run the migrate task
    Then my database should have 0 pending migrations

  Scenario: Fully migrated database
    Given I have 2 migrated migrations
    When I rollback my last migration
    Then my database should have 1 pending migrations
