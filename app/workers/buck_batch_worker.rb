class BuckBatchWorker
  include Sidekiq::Worker

  def perform person_id, school_id, state, bucks, batch_id
    person = Person.find(person_id)
    school = Person.find(school_id)
    bank = Bank.new
    bucks.symbolize_keys!
    batch = BuckBatch.find(batch_id)
    bank.create_print_bucks(person, school, state, bucks, batch)
    batch.update_attribute(:processed, true)
  end
end
