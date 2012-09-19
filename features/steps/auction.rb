class Auctions < Spinach::FeatureSteps
  Given 'an auction exists' do
    @auction = FactoryGirl.create(:auction)
  end

  Then 'the auction\'s current bid should be 0' do
    validate_current_bid('0')
  end

  Given 'two students exist with sufficient credits' do
    @student1 = FactoryGirl.create(:student)
    @student2 = FactoryGirl.create(:student)

    # Prepare a creditmanager instance
    @credit_manager = CreditManager.new

    # Create the main liability account for LE
    Plutus::Liability.create(name: @credit_manager.main_account_name)

    # Prepare a school
    @school = FactoryGirl.create(:school)

    # Issue some credits to the school
    @school_credits = 200_000
    @teacher_credits = 50_000
    @credit_manager.issue_credits_to_school(@school, @school_credits)
    @credit_manager.issue_store_credits_to_school(@school, @school_credits * 2)

    # Create a teacher
    @teacher = FactoryGirl.create(:teacher,:user => FactoryGirl.create(:spree_user,:username => 'teacher'))
    @teacher.activate
    @teacher.save
    @teacher_link = FactoryGirl.create(:person_school_link, school: @school, person: @teacher)

    # Give the teacher some credits
    @credit_manager.issue_credits_to_teacher(@school, @teacher, @teacher_credits)

    # Give a student some credits
    @student_credits = 10000
    @credit_manager.issue_ecredits_to_student(@school, @teacher, @student1, @student_credits)
    @credit_manager.issue_ecredits_to_student(@school, @teacher, @student2, @student_credits)
  end

  When 'the first student bids on the auction for $2.00' do
    bid(@student1, '2')
  end

  Then 'the auction\'s current bid should be $2.00' do
    validate_current_bid('2')
  end

  When 'the second student bids on the auction for $1.00' do
    bid(@student2, '1')
  end

  When 'the second student bids on the auction for $3.00' do
    bid(@student2, '3')
  end

  Then 'the auction\'s current bid should be $3.00' do
    validate_current_bid('3')
  end

  def bid(person, amount)
    amount = BigDecimal(amount)
    bid = BidOnAuctionCommand.new({
      auction: @auction,
      person: person,
      amount: amount,
      credit_manager: @credit_manager
    })
    bid.execute!
  end

  def validate_current_bid(amount)
    @auction.current_bid.must_equal BigDecimal(amount)
  end
end
