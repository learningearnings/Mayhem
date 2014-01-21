require_relative '../../../test_helper'
require_relative '../../../../app/models/importers/le/local_rewards_importer'

module Teachers; end
class Teachers::Reward; end
class Classroom; end

describe Importers::Le::LocalRewardsImporter do
  let(:file_path){ File.expand_path("../../../../support/files/le/local_rewards.csv", __FILE__) }
  let(:reward1){ Object.new }
  let(:reward2){ Object.new }
  let(:lego_building_category_id){ 1 }
  let(:sidewalk_chalk_art_category_id){ 2 }
  let(:classroom1){ Object.new }
  let(:classroom2){ Object.new }
  let(:classroom1_id){ 3 }
  let(:classroom2_id){ 4 }
  subject { Importers::Le::LocalRewardsImporter.new(file_path.to_s) }

  before do
    classroom1.stubs(:id).returns(classroom1_id)
    classroom2.stubs(:id).returns(classroom2_id)
    Classroom.stubs(:where).with(legacy_classroom_id: "400").returns([classroom1])
    Classroom.stubs(:where).with(legacy_classroom_id: "401").returns([classroom2])
  end

  it "takes a filename as its only argument" do
    subject.file_path.must_equal file_path.to_s
  end

  it "instantiates and saves a Teachers::Reward model for each separate reward, collecting up their classroom ids" do
    Teachers::Reward.expects(:new).with(name: "Lunchroom Lego Building", category: lego_building_category_id, on_hand: '9916', classrooms: [classroom1_id, classroom2_id]).returns(reward1)
    reward1.expects(:save)
    Teachers::Reward.expects(:new).with(name: "Sidewalk Chalk Art", category: sidewalk_chalk_art_category_id, on_hand: '9931', classrooms: [classroom1_id]).returns(reward2)
    reward2.expects(:save)
    subject.call
  end
end
