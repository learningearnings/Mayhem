class HonorRollWorker
  include Sidekiq::Worker

  def perform
    School.each do |school|
      honor_roll = HonorRoll.new(school, 7.days.ago.beginning_of_day, Date.today.end_of_day).deposits_per_person(3)
      HonorRollDeposit.delete_all
      honor_roll.each do |k, v|
        HonorRollDeposit.create(:student_id => k.id, :amount => v)
      end
    end
  end


end


