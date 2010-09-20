Feature: User Migrations

  In order to create a great application
  I should be able to use my migrations

  Background:
    Given I generate a Rails application with mongo migrations

  Scenario: Empty Database
    Given I have 2 pending migrations
    When I run the migrate task
    Then my database should have 0 pending migrations
    And I should see "TestMigration0: migrated" in the stdout
    And I should see "TestMigration1: migrated" in the stdout
    And I should have the proper collections and records in the database

  Scenario: Fully migrated database
    Given I have 2 migrated migrations
    When I rollback my last migration
    Then my database should have 1 pending migrations
    And the down step of the removed migration should have executed
