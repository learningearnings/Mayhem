# GameCredits

So playing a game provides credits.  For instance, if you win a FoodFight
question, you might get $0.20 in rewards.

This amount accrues over time.  So if you've not yet 'cashed in' on your
rewards, your OtuCode generated to store your accrued FoodFight rewards will
just grow in value.

This has to be generic, so there needs to be a top level concept of a GameCredit
that has an api like the following:

    credit = GameCredit.new('FF', student_id) # Where a GameCredit is initialized with a 'prefix' and a person's id
    credit.increment!(BigDecimal('0.2')) # This will increment the existing OtuCode or create a new one for that amount

A GameCredit has an `otu_code` method that finds or initializes an OtuCode with
that prefix, for this student, that has not yet been cashed in.  Then, when
increment! is called, it adds the increment to it and saves it.
