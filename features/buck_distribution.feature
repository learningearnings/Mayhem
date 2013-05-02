Feature: Buck Distribution
  As a cron job
  I should be able to distribute bucks to schools and teachers
  So that they have the appropriate amount of bucks

  Scenario: Distributing bucks to schools
    Given school1 has 7 active students
      And school2 has 3 active students
     When I run the BuckDistributor
     Then school1 should have 4900 credits
      And school2 should have 2100 credits
