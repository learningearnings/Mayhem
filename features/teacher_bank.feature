Feature: Teacher Bank
  As a teacher, I want to create printed bucks

  Background:
    Given the main LE account exists
    Given accounts exist
    Given accounts have bucks
    Given the default filter exists
    Given I am logged in as a teacher

    Scenario: Create Printed Bucks
      Given I am on the teachers bank page
      Given I distribute printed bucks
      Then the teacher account should be deducted
      
    Scenario: Create eBucks
      Given I am on the teachers bank page
      Given I distribute ebucks
      Then the teacher account should be deducted for ebucks
