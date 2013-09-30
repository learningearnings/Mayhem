require 'test_helper_with_rails'

describe OtuCode do
  describe "#person_school_link" do
    before do
      @teacher_school_link = FactoryGirl.create(:teacher_school_link)
      @otu_code           = FactoryGirl.create(:otu_code, :person_school_link_id => @teacher_school_link.id)
    end

    it "has a person_school_link" do
      @otu_code.person_school_link.must_equal @teacher_school_link
    end

    describe "#teacher" do
      it "defers to person_school_link#person" do
        @otu_code.teacher.must_equal @teacher_school_link.person
      end
    end

    describe "#school" do
      it "defers to person_school_link#school" do
        @otu_code.school.must_equal @teacher_school_link.school
      end
    end
  end

  describe "#is_ebuck?" do
    before do
      @otu_code = OtuCode.new :ebuck => true
    end

    it "returns the correct boolean value" do
      @otu_code.is_ebuck?.must_equal true
      @otu_code.ebuck = false
      @otu_code.is_ebuck?.must_equal false
    end
  end

  describe "source_string" do
    describe "when given by a teacher" do
      before do
        @teacher_school_link = FactoryGirl.create(:teacher_school_link)
        @otu_code           = FactoryGirl.create(:otu_code, :person_school_link_id => @teacher_school_link.id)
      end

      it "returns the teacher's to_s" do
        @otu_code.source_string.must_equal @teacher_school_link.person.to_s
      end
    end

    describe "when given by a game" do
      it "returns the game's name" do
        @otu_code = OtuCode.new :ebuck => true
        @otu_code.code = 'FFasdf'
        @otu_code.source_string.must_equal 'Food Fight'
      end
    end
  end
end
