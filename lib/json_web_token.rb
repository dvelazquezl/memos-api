class JsonWebToken
  class << self
    def encode(payload, exp = 12.hours.from_now)
      payload[:exp] = exp.to_i
      JWT.encode(payload, Rails.application.secrets.jwt_secret_key)
    end

    def decode(token)
      decoded = JWT.decode(token, Rails.application.secrets.jwt_secret_key)[0]
      HashWithIndifferentAccess.new decoded
    rescue JWT::DecodeError
      nil
    end
  end
end
