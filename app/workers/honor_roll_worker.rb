class HonorRollWorker
  include Sidekiq::Worker

  def perform
    School.all.each do |school|
      HonorRollDeposit.delete_all
      honor_roll = HonorRoll.new(school, 7.days.ago.beginning_of_day, Date.today.end_of_day).deposits_per_person(3)
      honor_roll.each do |k, v|
        HonorRollDeposit.create(:student_id => k.id, :amount => v, :school_id => school.id)
      end
    end
  end


end


