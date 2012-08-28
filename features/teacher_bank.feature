@javascript
Feature: Teacher Bank
  As a teacher, I want to create printed bucks

  Background:
    Given the main account exists
    Given accounts exist
    Given accounts have bucks
    Given I am logged in as a teacher

    Scenario: Create Printed Bucks
      Given I am on the bank page
      Given I distribute bucks
      Then show me the page
      Then the teacher account should be deducted
      




