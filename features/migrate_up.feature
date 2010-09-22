Feature: Migrate up and down

  In order to migrate data in my mongo database easily
  As a Rails developer
  I should be able to run my mongo migrations

  Background:
    Given I generate a Rails application with mongo migrations

  Scenario: Run the migrations up
    When I run "script/generate mongo_migration create_articles"
    And I edit the last migration's up method to be:
      """
        db.create_collection("articles")
      """
    And I run "script/generate mongo_migration add_a_document"
    And I edit the last migration's up method to be:
      """
        db["articles"].insert("name" => "Sports cars")
      """
    And I run "bundle exec rake mongo:migrate"

    Then I should see "CreateArticles: migrated"
    And I should see "AddADocument: migrated"
    And the migrations collection should have documents for each migration
    And the "articles" collection should have a document with a "name" of "Sports cars"

    When I run "bundle exec rake mongo:migrate:down"
    Then the migrations collection should be empty
