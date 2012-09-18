require 'test_helper'
require_relative '../../app/models/bank'

# NOTE: This test is not great looking, but I believe that to be a result of Bank
# doing too many things and exposing its collaborators' APIs too readily.
describe Bank do
  subject { Bank.new(credit_manager, buck_printer) }
  let(:credit_manager) { mock "Credit Manager" }
  let(:buck_printer) { mock "Buck Printer" }

  it "creates print bucks" do
    # NOTE: All the mocks suggest this guy does too much and depends on too many
    # infinite APIs
    on_success = lambda{}
    buck_creator = mock "OtuCode"
    person = mock "Person"
    person.stubs(:id)
    person_school_links = mock "Person School Links collection"
    person.stubs(:person_school_links).returns(person_school_links)
    person_school_link = mock "Person School Link"
    person_school_link.stubs(:id).returns(2)
    person_school_links.stubs(:where).returns([person_school_link])
    school = mock "School"
    school.stubs(:id).returns(1)
    account = mock "Account"
    person.expects(:main_account).with(school).returns(account)
    account.expects(:balance).returns(BigDecimal('1000'))
    prefix = 'AL'
    bucks = {
      ones: 1,
      fives: 0,
      tens: 0
    }
    buck_creator = mock "OtuCode"
    buck = mock "Buck"
    buck.stubs(:id).returns(1)
    buck_creator = lambda{ |params| return buck }
    buck.expects(:generate_code).with(prefix).at_least_once
    buck_batch_link_creator = mock "BuckBatchLink"
    buck_batch_creator = mock "BuckBatch"
    buck_batch = mock "BuckBatch instance"
    buck_batch.stubs(:id)
    buck_batch_creator.stubs(:call).returns(buck_batch)

    buck_batch_link_creator.stubs(:call)
    subject.stubs(:buck_creator).returns(buck_creator)
    subject.stubs(:buck_batch_link_creator).returns(buck_batch_link_creator)
    subject.stubs(:buck_batch_creator).returns(buck_batch_creator)
    subject.on_success = on_success

    on_success.expects(:call)
    credit_manager.expects(:purchase_printed_bucks).with(school, person, 1, buck_batch)
    # NOTE: We need to also expect that it creates all the bucks
    subject.create_print_bucks(person, school, prefix, bucks)
  end

  it "creates ebucks" do
    on_success = lambda {}
    person = mock "Person"
    school = mock "School"
    school.stubs(:id).returns(3)
    student = mock "Student"
    student.stubs(:id).returns(1)
    account = mock "Account"
    prefix = "AL"
    person_school_links = mock "Person School Links collection"
    person.stubs(:person_school_links).returns(person_school_links)
    person_school_link = mock "Person School Link"
    person_school_link.stubs(:id).returns(2)
    person_school_links.stubs(:where).returns([person_school_link])
    person.expects(:main_account).with(school).returns(account)
    account.expects(:balance).returns(BigDecimal('1000'))
    buck = mock "Buck"
    buck.expects(:code).returns(2)
    buck_creator = lambda{ |params| return buck }
    message_creator = lambda{ |params| return true }
    buck.expects(:generate_code).with(prefix).at_least_once
    subject.stubs(:buck_creator).returns(buck_creator)
    subject.stubs(:message_creator).returns(message_creator)
    subject.on_success = on_success

    on_success.expects(:call)
    credit_manager.expects(:purchase_ebucks).with(school, person, student, 1)
    subject.create_ebucks(person, school, student, prefix, 1)
  end

  it "claims bucks" do
    skip
  end
end
