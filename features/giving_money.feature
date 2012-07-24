@wip
Feature: Giving Credits
  As an administrator, I want to give teachers credits
  As an administrator, I want to give students credits
  As an administrator, I want to give schools credits
  As a teacher, I want to give schools credits
  
  Scenario: End of the Month
    Given I am an administrator
    When a school exists with credits
    And I take away all of the schools credits
    Then that school should have 0 credits
    
  Scenario: First of the Month
    When a school exists with a student
    And I give a school 10000 credits
    Then that school should have 10000 credits

  Scenario: Giving a teacher credits
#    Given I am a school??
    And I have 10000 credits to give
    And I give a teacher 1000 credits
    Then that teacher should have 1000 credits to give
    And I should have 9000 credits to give

  Scenario: Giving a student credits
#    Given I am a teacher at a school with students
    When I have 1000 credits to give
    And I give a student 10 credits
    Then I should have 990 credits

  Scenario: Giving multiple students credits
#    Given I am a teacher at a school with students
    When I have 1000 credits to give
    And I give 2 students 5 credits each
    Then I should have 990 credits
    
  Scenario: Students spending credits
#    Given I am a student
    When I have 100 credits
    And I purchase a reward that cost 5 credits
    Then I should have 95 credits