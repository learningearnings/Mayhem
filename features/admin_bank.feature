@javascript
Feature: Admin Bank
  As a school admin, I want to create printed bucks

  Background:
    Given the main account exists
    Given accounts exist
    Given accounts have bucks
    Given I am logged in as an admin

    Scenario: Create Printed Bucks
      Given I am on the bank page
      Given I distribute bucks
      Then the admin account should be deducted
      Given I distribute bucks for a teacher
      Then the teacher account should be deducted
      




