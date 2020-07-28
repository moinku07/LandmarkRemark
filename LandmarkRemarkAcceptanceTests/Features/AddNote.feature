Feature: Adding Note

Scenario: As a user I can see my current location on a map

Given I launch the app
Then I should see my current location on a map

Scenario: As a user I can save a short note at my current location

Given I tap on my current location marker
When I add note
Then It should save

Scenario: As a user I can see notes that I have saved at the location they were saved on the map

Given I launch the app
Then I should see the note I saved at the location they were saved on the map

Scenario: As a user I can see the location, text, and user-name of notes other users have saved

Given I launch the app
Then I should see the location, text, and user-name of notes other users have saved

Scenario: As a user I have the ability to search for a note based on contained text or user-name

Given I launch the app
Then I should able to search for a note based on contained text or user-name
