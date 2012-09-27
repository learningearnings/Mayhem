require 'test_helper_with_rails'

describe GameCredit do
  before do
    @student_id = mock "Student id"
    @chain = mock 'activerelation chain'
    @code = mock 'new or found otu code'
    OtuCode.expects(:ebuck).returns(@chain)
    @chain.expects(:where).with("code LIKE ?", 'FF%').returns(@chain)
  end

  it 'finds an OtuCode for the student_id' do
    @chain.expects(:where).with({ student_id: @student_id }).returns([@code])
    credit = GameCredit.new 'FF', @student_id
    credit.otu_code.must_equal @code
  end

  it 'initializes an unsaved OtuCode if no code is found' do
    @chain.expects(:where).with({ student_id: @student_id }).returns([])

    new_code = mock
    OtuCode.expects(:new).returns(new_code)
    new_code.expects(:ebuck=).with(true)
    new_code.expects(:student_id=).with(@student_id)
    new_code.expects(:points=).with(BigDecimal('0'))
    new_code.expects(:generate_code).with('FF')

    credit = GameCredit.new 'ff', @student_id
    credit.otu_code.must_equal new_code
  end

  it 'increments the amount of the otu_code and saves it' do
    @chain.expects(:where).with({ student_id: @student_id }).returns([@code])
    credit = GameCredit.new 'FF', @student_id
    amount = BigDecimal('1')
    increment_amount = BigDecimal('0.5')
    @code.stubs(:points).returns(amount)
    @code.expects(:points=).with(amount + increment_amount)
    @code.expects(:save!)
    credit.increment!(increment_amount)
  end
end
