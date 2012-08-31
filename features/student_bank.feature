Feature: Student Bank
  As a student, I want to claim bucks

  Background:
    Given the main account exists
    Given accounts exist
    Given accounts have bucks
    Given I am logged in as a student

    Scenario: Claim Printed Bucks
      Given I am on the bank page
      Given a valid code exists 
      Then I enter the code
      Then the student account should recieve bucks

    Scenario: Claim eBucks
      Given a valid ecode exists 
      Given I am on the messages page
      Given I click on a buck message
      Then the student account should recieve bucks
