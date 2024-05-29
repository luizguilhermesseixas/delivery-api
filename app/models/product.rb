class Product < ApplicationRecord
  include Discard::Model
  belongs_to :store
  has_many :orders, through: :order_items
  
  validates :title, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  scope :kept, -> { undiscarded.joins(:store).merge(Store.kept) }

  def kept?
    undiscarded? && store.kept?
  end

end
