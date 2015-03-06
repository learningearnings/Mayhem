class AuthToken
  def self.encode(payload, exp=24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, Rails.application.config.secret_token)
  end

  def self.decode(token)
    payload = JWT.decode(token, Rails.application.config.secret_token)[0]
    DecodedAuthToken.new(payload)
  rescue
    nil
  end
end

class DecodedAuthToken < HashWithIndifferentAccess
  def expired?
    self[:exp] <= Time.now.to_i
  end
end
