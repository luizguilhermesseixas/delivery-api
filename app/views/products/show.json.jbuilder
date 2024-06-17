json.extract! @product, :id, :title, :description, :price, :created_at, :updated_at
json.price number_to_currency(@product.price)

json.store do
  json.extract! @product.store, :id, :name
end

if @product.image.attached?
  json.image_urls do
    json.thumbnail_url rails_blob_url(@product.thumbnail_image)
    json.detail_url rails_blob_url(@product.detail_image)
  end
end

json.url store_product_url(@store, @product, format: :json)