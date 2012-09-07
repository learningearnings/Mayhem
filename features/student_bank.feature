Feature: Student Bank
  As a student, I want to claim bucks

  Background:
    Given the main account exists
    Given accounts exist
    Given accounts have bucks
    Given I am logged in as a student

    Scenario: Claim Printed Bucks
      Given I have a printed buck's code
      Given I am on the bank page
      Then I enter the code
      Then the student account should receive bucks

    Scenario: Claim eBucks
      Given a teacher has sent me some ebucks
      Given I am on the messages page
      Given I click on a buck message
      Then the student account should receive bucks
