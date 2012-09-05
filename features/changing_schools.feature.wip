@wip
Feature: Changing Schools
  As a Person, I need to have the ability to change schools

  Scenario: Teacher changes Schools
    Given I am an LE Administrator
    When a teacher requests a school change
    And I change to the requested school
    Then the teacher should be a member of that school
    And the teacher should not be active at the previous school
    And the teacher should not have active objects at the previous school

  Scenario: Student changes Schools
    Given I am an LE Administrator
    When a student requests a school change
    And I change to to the requested school
    Then the student should be a member of that school
    And the student should not be a member of the previous school
