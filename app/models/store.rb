class Store < ApplicationRecord
  include Discard::Model

  belongs_to :user
  has_many :products
  
  before_discard :discard_products

  before_validation :ensure_seller
  validates :name, presence: true, length: { minimum: 3 }

  def undiscard
    super
    products.discarded.each(&:undiscard)
  end

  private

  def ensure_seller
    self.user = nil if self.user && !self.user.seller?
  end

  def discard_products
    products.each(&:discard)
  end
end
