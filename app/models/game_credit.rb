class GameCredit
  attr_reader :otu_code

  def initialize prefix, student_id
=begin
    @otu_code = OtuCode.ebuck.active.where("code LIKE ?", prefix.upcase + '%').where(student_id: student_id).first
    if @otu_code.nil?
      @otu_code = OtuCode.new
      @otu_code.ebuck = true
      @otu_code.student_id = student_id
      @otu_code.points = BigDecimal('0')
      @otu_code.generate_code(prefix.upcase)
    end
=end
  end

  def increment!(increment_amount)
    #@otu_code.points = @otu_code.points + increment_amount
    #@otu_code.save!
  end
end
