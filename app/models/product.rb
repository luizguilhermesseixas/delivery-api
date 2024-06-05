class Product < ApplicationRecord
  include Discard::Model
  belongs_to :store
  has_many :orders, through: :order_items
  has_one_attached :image
  
  validates :title, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  scope :kept, -> { undiscarded.joins(:store).merge(Store.kept) }

  def thumbnail_image
    image.variant(resize_to_limit: [100, 100]).processed
  end

  def detail_image
    image.variant(resize_to_limit: [400, 400]).processed
  end

  def kept?
    undiscarded? && store.kept?
  end

end
