Feature: Admin Bank
  As a school admin, I want to create printed bucks

  Background:
    Given the main account exists
    Given accounts exist
    Given accounts have bucks
    Given I am logged in as an admin
    Given I am on the school admins bank page

    Scenario: Create Printed Bucks
      Given I distribute printed bucks
      Then the admin account should be deducted
      Given I distribute bucks for a teacher
      Then the teacher account should be deducted
 
    Scenario: Create eBucks
      Given I distribute ebucks
      Then the admin account should be deducted
