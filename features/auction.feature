Feature: Auctions
  As an le admin, I want to create auctions
  So that students can bid on the items being auctioned

  Scenario: Students bid each other up on an auction
    Given an auction exists
    Then the auction's current bid should be 0
    Given two students exist with sufficient credits
    When the first student bids on the auction for $2.00
    Then the auction's current bid should be $2.00
    When the second student bids on the auction for $1.00
    Then the auction's current bid should be $2.00
    When the second student bids on the auction for $3.00
    Then the auction's current bid should be $3.00
