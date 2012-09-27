Feature: Game Credits From Food Fight
  As a student
  I want to play food fight
  So that I can gain credits

  Scenario: Student plays food fight once
    Given a student exists
    And a code exists
    And a food fight question exists
    When he answers a food fight question correctly
    Then he should have a corresponding otu code waiting to be claimed

  Scenario: Student plays food fight twice
    Given a student exists
    And a code exists
    And a food fight question exists
    When he answers a food fight question correctly
    And he answers a food fight question correctly
    Then he should have a single otu code waiting to be claimed for twice the single-play amount
