Feature: School Settings
  As a school admin, I want to view and edit school settings
  to designate teachers as reward distributors

  Background:
    Given the main LE account exists
    Given accounts exist
    Given accounts have bucks
    Given the default filter exists
    Given I am logged in as an admin


  Scenario: School Admin views the settings page
    Given I am on the schools settings page
