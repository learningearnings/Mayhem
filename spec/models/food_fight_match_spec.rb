require_relative '../spec_helper'

describe FoodFightMatch do

  before :each do
    @food_fight_match = FactoryGirl.create(:food_fight_match)
    @player1 = FactoryGirl.create(:food_fight_player, food_fight_match_id: @food_fight_match.id, questions_answered: 1, score: 0)
    @food_fight_match.update_attributes(initiated_by: @player1.id)
    @player2 = FactoryGirl.create(:food_fight_player, food_fight_match_id: @food_fight_match.id, questions_answered: 1, score: 1)
  end

  it 'should keep track of players scores' do
    @player1.add_score
    expect(@player1.score).to equal(1)
  end

  it 'should expect players to know their opponent' do
    expect(@player1.opponent).to eql(@player2)
  end

  it 'should have 2 players' do
    expect(@food_fight_match.players).to eql([@player1, @player2])
  end

  it 'should have a winner' do
    @food_fight_match.end!
    expect(@food_fight_match.winner_id).to eql(@player2.id)
  end

  it 'should not be actve after it has ended' do
    @food_fight_match.end!
    expect(@food_fight_match.active).to eql(false)
  end

  it 'should have a loser' do
    expect(@food_fight_match.loser).to eql(@player1)
  end

  it 'should have a winner' do
    expect(@food_fight_match.winner).to eql(@player2)
  end

  it 'should handle turn changes' do
    @food_fight_match.change_turn
    expect(@food_fight_match.turn).to eql(@player2)
  end

end
