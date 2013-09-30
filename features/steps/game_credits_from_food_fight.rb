class GameCreditsFromFoodFight < Spinach::FeatureSteps
  Given 'a student exists' do
    @student = FactoryGirl.create(:student)
  end

  Given 'a code exists' do
    Code.create active: true
  end

  Given 'a food fight question exists' do
    @question1 = FactoryGirl.create(:food_fight_question, body: "Find the least common multiple for each number pair 6 27")
    @answer1 = FactoryGirl.create(:food_fight_answer, body: "54")
    @answer1_link = FactoryGirl.create(:game_question_answer, question: @question1, answer: @answer1, correct: true)
  end

  When 'he answers a food fight question correctly' do
    command = FoodFightPlayCommand.new question_id: @question1.id, answer_id: @answer1.id
    command.person_id = @student.id
    command.execute!
  end

  Then 'he should have a corresponding otu code waiting to be claimed' do
    otu_code = @student.otu_codes.first
    otu_code.code[0..1].must_equal 'FF'
    otu_code.points.must_equal BigDecimal('0.2')
  end

  Then 'he should have a single otu code waiting to be claimed for twice the single-play amount' do
    otu_code = @student.otu_codes.first
    otu_code.code[0..1].must_equal 'FF'
    otu_code.points.must_equal BigDecimal('0.2') * 2
  end
end
