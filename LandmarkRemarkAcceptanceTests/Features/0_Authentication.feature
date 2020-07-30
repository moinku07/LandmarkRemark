Feature: Authentication

Scenario: As a user when I launch the app for the first time I should see login screen

Given I launch the app for the first time
Then I should see login screen


Scenario: As a user when I enter user credentials and tap login I should see map view

Given I launch the app
When I enter user credentials "johnsmith,123456" and tap login
Then I should see map view
