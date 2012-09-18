This document defines the auction architecture for traditional auctions.

1) There is a start date.  This defines the date that the auction is visible to
students.
2) There is an end date.  The auction accepts no new bids after this date.  The
highest bidder on this date wins.
3) There is no bid limit.
4) Students will have credits bid on a given auction locked, and those credits
are unlocked when they are outbid.
5) When a student is outbid, they are notified.
6) Starting price defaults to 1 credit, and students bid it up from there.
7) There is a simple administrative interface to view/filter all auctions.
8) There is an auction status screen that shows the status of all auctions at a
glance.

## Data Model
### Auction
This is the high level data model for a given auction.  It has the following
attributes:

- `start_date`
- `end_date`
- `current_bid`
- `auction_type` - presently, this will always be "traditional"
- `product_id`

It has the following methods:

- `number_of_bidders`
- `number_of_bids`
- `leading_bidder`

## Command Model
### BidOnAuction
This command will place a bid on an auction for a given person.
