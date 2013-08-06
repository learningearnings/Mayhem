Feature: Teacher Bank
  As a teacher, I want to create printed bucks

  Background:
    Given the main LE account exists
    Given accounts exist
    Given accounts have bucks
    Given the default filter exists
    Given I am logged in as a teacher

    Scenario: Create Printed Bucks when authorized
      Given I am authorized to distribute credits
      Given I am on the teachers bank page
      Given I distribute printed bucks
      Then the teacher account should be deducted
      
    Scenario: Create eBucks when authorized
      Given I am authorized to distribute credits
      Given I am on the teachers bank page
      Given I distribute ebucks
      Then the teacher account should be deducted for ebucks

    Scenario: Transfer Credits to another teacher when authorized
      Given I am authorized to distribute credits
      Given I am on the teachers bank page
      Given I transfer credits to another teacher
      Then the teacher should have the credits deducted
      And the other teacher should have the credits credited

    Scenario: Create Printed Bucks when unauthorized
      Given I am on the teachers bank page
      Then I should not see the option to distribute printed bucks
      
    Scenario: Create eBucks when unauthorized
      Given I am on the teachers bank page
      Then I should not see the option to distribute ebucks
