class ProductsController < ApplicationController
  before_action :authenticate_user!

  def index
    respond_to do |format|
      format.json do
        if buyer?
          @products = Product.where(store_id: params[:store_id]).order(:title)
        end
      end
    end
  end

  def listing
    if !current_user.admin?
      redirect_to root_path, notice: "No permission for you!"
    end
    @products = Product.includes(:store)
  end

end
