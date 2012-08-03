require 'test_helper'

describe FilterFactory do
  subject { FilterFactory }

  before do

    require "#{Rails.root}/db/seeds.rb"
    @school_1 = School.create(:name => "FilterFactory School 1 (AL)")
    @school_2 = School.create(:name => "FilterFactory School 2 (GA)")
    @school_3 = School.create(:name => "FilterFactory School 3 (FL)")
    @school_4 = School.create(:name => "FilterFactory School 4 (TN)")

    @alabama = State.find_by_abbr('AL')
    @georgia = State.find_by_abbr('GA')
    @florida = State.find_by_abbr('FL')
    @tennessee = State.find_by_abbr('TN')

    @school_1.addresses << Address.create(:line1 => '123 Main Street',
                                          :line2 => nil,
                                          :state => @alabama,
                                          :zip => '35124')



    @school_1_classroom_1 = Classroom.create(:name => 'FilterFactory School 1 Classroom 1')
    @school_1_classroom_2 = Classroom.create(:name => 'FilterFactory School 1 Classroom 2')
    @school_1_classroom_3 = Classroom.create(:name => 'FilterFactory School 1 Classroom 3')
    @school_1_classroom_4 = Classroom.create(:name => 'FilterFactory School 1 Classroom 4')
    @school_1_classroom_5 = Classroom.create(:name => 'FilterFactory School 1 Classroom 5')
    @school_1_classroom_6 = Classroom.create(:name => 'FilterFactory School 1 Classroom 6')

    @school_2_classroom_1 = Classroom.create(:name => 'FilterFactory School 2 Classroom 1')
    @school_2_classroom_2 = Classroom.create(:name => 'FilterFactory School 2 Classroom 2')
    @school_2_classroom_3 = Classroom.create(:name => 'FilterFactory School 2 Classroom 3')
    @school_2_classroom_4 = Classroom.create(:name => 'FilterFactory School 2 Classroom 4')
    @school_2_classroom_5 = Classroom.create(:name => 'FilterFactory School 2 Classroom 5')
    @school_2_classroom_6 = Classroom.create(:name => 'FilterFactory School 2 Classroom 6')

    @school_3_classroom_1 = Classroom.create(:name => 'FilterFactory School 3 Classroom 1')
    @school_3_classroom_2 = Classroom.create(:name => 'FilterFactory School 3 Classroom 2')
    @school_3_classroom_3 = Classroom.create(:name => 'FilterFactory School 3 Classroom 3')
    @school_3_classroom_4 = Classroom.create(:name => 'FilterFactory School 3 Classroom 4')
    @school_3_classroom_5 = Classroom.create(:name => 'FilterFactory School 3 Classroom 5')
    @school_3_classroom_6 = Classroom.create(:name => 'FilterFactory School 3 Classroom 6')

    @school_4_classroom_1 = Classroom.create(:name => 'FilterFactory School 4 Classroom 1')
    @school_4_classroom_2 = Classroom.create(:name => 'FilterFactory School 4 Classroom 2')
    @school_4_classroom_3 = Classroom.create(:name => 'FilterFactory School 4 Classroom 3')
    @school_4_classroom_4 = Classroom.create(:name => 'FilterFactory School 4 Classroom 4')
    @school_4_classroom_5 = Classroom.create(:name => 'FilterFactory School 4 Classroom 5')
    @school_4_classroom_6 = Classroom.create(:name => 'FilterFactory School 4 Classroom 6')

    @school_1_classrooms = [@school_1_classroom_1,
                            @school_1_classroom_2,
                            @school_1_classroom_3,
                            @school_1_classroom_4,
                            @school_1_classroom_5,
                            @school_1_classroom_6]

    @school_2_classrooms = [@school_2_classroom_1,
                            @school_2_classroom_2,
                            @school_2_classroom_3,
                            @school_2_classroom_4,
                            @school_2_classroom_5,
                            @school_2_classroom_6]

    @school_3_classrooms = [@school_3_classroom_1,
                            @school_3_classroom_2,
                            @school_3_classroom_3,
                            @school_3_classroom_4,
                            @school_3_classroom_5,
                            @school_3_classroom_6]

    @school_4_classrooms = [@school_4_classroom_1,
                            @school_4_classroom_2,
                            @school_4_classroom_3,
                            @school_4_classroom_4,
                            @school_4_classroom_5,
                            @school_4_classroom_6]



    @teacher = 'Teacher'
    @student = 'Student'
    @school_admin = 'SchoolAdmin'
    @le_admin = 'LeAdmin'

  end

  after do
    if @school_1_classrooms && 
        @school_2_classrooms &&
        @school_3_classrooms &&
        @school_4_classrooms
      @school_1_classrooms.each do |c|
        c.destroy
      end
      @school_2_classrooms.each do |c|
        c.destroy
      end
      @school_3_classrooms.each do |c|
        c.destroy
      end
      @school_4_classrooms.each do |c|
        c.destroy
      end
    end

    @school_1.destroy if @school_1
    @school_2.destroy if @school_2
    @school_3.destroy if @school_3
    @school_4.destroy if @school_4
  end

  it "has the basics down" do
    subject.must_be_kind_of Class
  end

  it "can find the all inclusive filter" do
    ff = FilterFactory.new
    f = ff.find_or_create_filter
    f.wont_be_nil
  end

  it "can create a filter that doesn't exist" do
    fc = FilterConditions.new
    fc << @school_1
    ff = FilterFactory.new
    f = ff.find_or_create_filter(fc)
    f.must_be :valid?
    f.wont_be_nil
    f.save
    f.id.wont_be_nil
  end

  it "can create a filter and find it later" do
    fc = FilterConditions.new
    fc << @school_2
    ff = FilterFactory.new
    f = ff.find_or_create_filter(fc)
    f.must_be :valid?
    f.wont_be_nil
    f.save
    f1 = ff.find_or_create_filter(fc)
    f.id.must_equal(f1.id)
  end
=begin
  it "can find state-only filter membership" do
  end

  it "can find school-only filter membership" do
  end

  it "can find person-class-only filter membership" do
  end

  it "can find school-classroom filter membership" do
  end

  it "can find grade filter membership" do
  end
=end
end

