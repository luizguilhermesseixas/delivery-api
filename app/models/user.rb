class User < ApplicationRecord
  enum role: [:admin, :seller, :buyer]
  validates :role, presence: true

  has_many :stores

  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable

  class InvalidToken < StandardError; end

  def self.from_token(token)
    decoded = JWT.decode token, "muito.secreto", true, {algorithm: "HS256"}
    user_data = decoded[0].with_indifferent_access
    User.find(user_data[:id])
    rescue JWT::ExpiredSignature
      raise InvalidToken.new
  end

  def self.token_for(user)
    jwt_headers = {exp: 1.hour.from_now.to_i}
    payload = {id: user.id, email: user.email, role: user.role}
    JWT.encode(payload.merge(jwt_headers), "muito.secreto", "HS256")
  end

end
