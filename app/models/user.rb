class User < ApplicationRecord
  enum role: [:admin, :seller, :buyer]
  has_many :stores

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def self.from_token(token)
    decoded = JWT.decode token, "muito.secreto", true, {algorithm: "HS256"}
    user_data = decoded[0].with_indifferent_access
    User.find(user_data[:id])
  end

  def self.token_for(user)
    payload = {id: user.id, email: user.email, role: user.role}
    JWT.encode payload, "muito.secreto", "HS256"
  end
end
