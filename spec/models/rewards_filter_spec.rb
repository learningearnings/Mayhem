require_relative '../spec_helper'

describe RewardsFilter do
  describe "#by_classroom" do
    it "returns the products provided if person is not a student" do
      teacher = FactoryGirl.build(:teacher)
      products = []
      expect(described_class.by_classroom(teacher, products)).to eql(products)
    end

    it "shows non-classroom products and products in this student's classroom" do
      student = FactoryGirl.create(:student)
      classroom       = FactoryGirl.create(:classroom)
      other_classroom = FactoryGirl.create(:classroom, school: classroom.school)
      student << classroom
      student.reload
      non_classroom_product   = FactoryGirl.create(:spree_product, name: "Non Classroom")
      classroom_product       = FactoryGirl.create(:spree_product, name: "Classroom", classrooms: [classroom])
      other_classroom_product = FactoryGirl.create(:spree_product, name: "Other Classroom", classrooms: [other_classroom])

      expected_results = [non_classroom_product, classroom_product]
      results = described_class.by_classroom(student, Spree::Product.scoped)

      expect(results.order("id ASC")).to eq(expected_results)
    end
  end
end
