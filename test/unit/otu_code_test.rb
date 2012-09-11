require 'test_helper'
require_relative '../../app/models/otu_code.rb'

describe OtuCode do
  describe "OTUCode#person_school_link" do
    before do
      @person_school_link = FactoryGirl.create(:person_school_link)
      @otu_code           = FactoryGirl.create(:otu_code, :person_school_link_id => @person_school_link.id)
    end

    it "should return the linked person school link" do
      assert_equal @otu_code.person_school_link, @person_school_link
    end

    describe "OtuCode#teacher" do
      it "should return person_school_link#person" do
        assert @otu_code.teacher, @person_school_link.person
      end
    end

    describe "OtuCode#school" do
      it "should return person_school_link#school" do
        assert @otu_code.school, @person_school_link.school
      end
    end
  end

  describe "OtuCode#is_ebuck?" do
    before do
      @otu_code = OtuCode.new :ebuck => true
    end

    it "should return the correct boolean value" do
      assert @otu_code.is_ebuck?
      @otu_code.ebuck = false
      assert_equal @otu_code.is_ebuck?, false
    end

  end
end
