class BuckDistribution < Spinach::FeatureSteps
  Given 'school1 has 7 active students' do
    Plutus::Liability.create(name: 'MAIN_ACCOUNT')
    @school1 = FactoryGirl.create(:school)
    7.times do
      link = FactoryGirl.create(:student_school_link, school: @school1)
      link.activate
      link.person.activate
    end
  end

  And 'school2 has 3 active students' do
    @school2 = FactoryGirl.create(:school)
    3.times do
      link = FactoryGirl.create(:student_school_link, school: @school2)
      link.activate
      link.person.activate
    end
  end

  When 'I run the BuckDistributor' do
    @buck_distributor = BuckDistributor.new
    @buck_distributor.handle_schools
  end

  Then 'school1 should have 4900 credits' do
    @school1.balance.must_equal BigDecimal('4900')
  end

  And 'school2 should have 2100 credits' do
    @school2.balance.must_equal BigDecimal('2100')
  end
end
