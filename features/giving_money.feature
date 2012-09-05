@wip
Feature: Giving Credits
  As an administrator, I want to give teachers credits
  As an administrator, I want to give students credits
  As an administrator, I want to give schools credits
  As a teacher, I want to give schools credits

  Background:
    Given the main LE account exists

  Scenario: End of the Month
    Given a school exists with credits
     Then that school should have some credits
     When I take away all of the schools credits
     Then that school should have 0 credits
      And the main LE account should have the amount of credits taken away

  Scenario: First of the Month
    Given a school exists with a student
     When I give a school 10000 credits
     Then that school should have 10000 credits
      And the main LE account should have 10000 credits less

  Scenario: Giving a teacher credits
    Given a school has 10000 credits to give
      And a teacher is a member of that school
     When the school gives a teacher 1000 credits
     Then that teacher should have 1000 credits to give
      And the school should have 9000 credits to give

  Scenario: Giving a student credits
    Given I am a teacher at a school with students
     When I have 1000 credits to give
      And I give a student 10 credits
     Then I should have 990 credits
      And the student should have 10 credits in checking

  Scenario: Giving multiple students credits
    Given I am a teacher at a school with students
     When I have 1000 credits to give
      And I give 2 students 5 credits each
     Then I should have 990 credits
      And the first student should have 5 credits in checking
      And the second student should have 5 credits in checking

  Scenario: Students spending credits
    Given I am a student
     When I have 100 credits
      And I purchase a reward that cost 5 credits
     Then I should have 95 credits in checking
     
  Scenario: Students transferring credits from checking to savings
    Given I am a student
     When I have 200 credits in checking
      And I transfer 10 credits to savings
     Then I should have 190 credits in checking 
      And I should have 10 credits in savings
  
  Scenario: Students transferring credits from savings to checking
    Given I am a student
     When I have 50 credits in savings
      And I transfer 5 credits to checking
     Then I should have 45 credits in savings 
      And I should 5 credits in checking
     Then I should have 50 credits total

  Scenario: Attempting to spend more credits than available
    Given I am a student
     When I have 100 credits in checking
      And I attempt to purchase a reward that costs 105 credits
     Then I should have 100 credits in checking


