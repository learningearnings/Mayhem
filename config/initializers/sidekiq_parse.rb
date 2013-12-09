module Sidekiq
  def self.load_json(string)
    MultiJson.load(string)
  end

  def self.dump_json(object)
    MultiJson.dump(object)
  end
end
