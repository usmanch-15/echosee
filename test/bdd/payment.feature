Feature: Payment Integration

  Scenario: User pays via EasyPaisa successfully
    Given the app is running
    And I am on the Premium Features screen
    When I tap "Upgrade Now" button
    And I select "EasyPaisa" payment method
    And I enter "03451234567" as mobile number
    And I tap "Pay" button
    Then I should see a "Success!" message
    And the transaction should be completed

  Scenario: User pays via Bank Card successfully
    Given the app is running
    And I am on the Premium Features screen
    When I tap "Upgrade Now" button
    And I select "Bank Card" payment method
    And I enter card details:
      | number           | expiry | cvv |
      | 4242424242424242 | 12/26  | 123 |
    And I tap "Pay" button
    Then I should see a "Success!" message
