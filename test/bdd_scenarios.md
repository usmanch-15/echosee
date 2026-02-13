# EchoSee BDD Scenarios (Day 1 - Day 7)

## Day 1 & 2: Project Setup & Authentication
  ### Scenario: User Registration and Basic Entry
    Given the app is freshly installed
    When I sign up with email "roman@example.com" and name "Roman"
    Then a profile should be created in Supabase
    And I should see the Home screen with my name "Roman"

## Day 3: Live Subtitles (Core)
  ### Scenario: Live Transcription animation
    Given I am on the Home screen
    When I tap the "START RECORDING" button
    Then I should see the "LIVE TRANSCRIPT:" header
    And I should see an animated stream of text appearing in the transcript box
    And the button text should change to "STOP RECORDING"

## Day 4: Storage & History Limits
  ### Scenario: History visibility for Free users
    Given I am a "Free" user
    And I have 10 transcripts in my account
    When I navigate to the History screen
    Then I should only be able to see the 5 most recent transcripts
    And I should see a banner suggesting I upgrade to Premium

  ### Scenario: History visibility for Premium users
    Given I am a "Premium" user
    And I have 10 transcripts in my account
    When I navigate to the History screen
    Then I should be able to see all 10 transcripts
    And the limit banner should be hidden

## Day 5: Settings & Cloud Sync
  ### Scenario: Updating and Syncing Preferences
    Given I am on the Settings screen
    When I change the font size to "20"
    And I toggle "Dark Mode" to ON
    Then the app UI should immediately reflect these changes
    And the settings should be automatically synced to my Supabase account

## Day 6: Premium Features
  ### Scenario: Speaker Labeling
    Given I am a "Premium" user
    And I am viewing a transcript with "Speaker 1" and "Speaker 2"
    When I tap on the label "Speaker 1"
    And I enter "Roman" as the name
    Then "Speaker 1" should be renamed to "Roman" in the history list

  ### Scenario: Voice Translation
    Given I am a "Premium" user
    When I select a transcript and tap "Translate"
    And I choose "Spanish"
    Then I should see a loading indicator
    And after a few seconds, "Traducción..." should appear below the English text

## Day 7: Final Polish & Errors
  ### Scenario: Graceful Error Handling
    Given I have no internet connection
    When I try to save a transcript
    Then I should see a red SnackBar with "Failed to save transcript"
    And the app should not crash
