@wip
Feature: Giving Money
  As a teacher, I want to give money to students

  Scenario: Giving a teacher credits
    Given I am an administrator
    And I give a teacher 1000 credits
    Then that teacher should have 1000 credits to give

  Scenario: Giving a student credits
    Given I am a teacher at a school with students
    When I have 1000 credits to give
    And I give a 10 gredits
    Then I should have 990 credits

  Scenario: Giving multiple students credits
    Given I am a teacher at a school with students
    When I have 1000 credits to give
    And I give 2 students 5 credits each
    Then I should have 990 credits
