# How SchoolAdmins (aka SuperTeachers) manage the school store

## Initial setup
*   When a school is setup all of the students are considered "active" for 45 days
*   New students are considered active for 45 days
*   The School has an account created called *Store Credits*
*   *Store Credits* are used by the SchoolAdmin to purchase items for the 
    on-site school inventory.   There should be a *School Store Catalog* of these things.
*   When the SchoolAdmin logs in and the school store is *NOT* active, she is 
    prompted to create the school store
*   Creating the store:
    * Credits are added to the *Store Credits* account based on the number of active students
        * Example - $100 Credits per active student x 100 active students = $10,000 store credits
        * Need a default Credits per student, and maybe an override per school or grade?  Need
          input from Adam / Jimmy on this...
    * A *Re-Order Threshold* is created based on the amount of credits initially added to the *Store Credits* account.
        * Example: $10,000 store credits * 50% - $5,000 Re-order threshold
    * SchoolAdmins can purchase goods from the *School Store Catalog* with the *Store Credits*
    * We should allow the SchoolAdmins to have a Cart for purchases from the *School Store Catalog*
    * *Store Credits* are reduced at checkout

## Ongoing
*   When students purchase items in the on-site inventory from the school store, the amount of the
    purchase is added back to the *Store Credits* for the school
*   When the amount in the *Store Credits* account is more than the *Re-Order Threshold*, the SchoolAdmin
    is prompted to make another order from the *School Store Catalog*
*   When students are added, a (??? pro-rated ???) amount is added to the *Store Credits* account
*   When students are removed, a (??? pro-rated ???) amount is deducted
    from the *Store Credits* account (??? if funds are available ???)


## Active Student Calculations...
*   It's acceptable to calculate the *active* students once a month when we allocate bucks
    to the school and teachers.


## Spree Configuration
*   The LE Administrator only manages Wholesale items
*   Wholesale items have the following properties (Spree Properties)
    * retail_quantity - Number of these items to add to the student visible store
    * retail_price - how many credits a student should pay for this item
    * 
*   When a School Administrator "purchases" an item with the school's Store Credit,
    that item is added to the store that the students see at the price indicated by
    retail_price on the wholesale item
