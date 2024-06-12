class ProductsController < ApplicationController
  skip_forgery_protection
  before_action :authenticate!, :set_locale!
  before_action :set_store!, only: [:index, :new, :create, :edit, :update, :destroy, :show]
  before_action :set_product!, only: [:show, :edit, :update, :destroy]

  # GET stores/:store_id/products
  def index
    respond_to do |format|
      format.json do
        if current_user.buyer? || current_user.seller?
          page = params.fetch(:page, 1)
          @products = Product.where(store_id: params[:store_id]).kept.order(:title).page(page)
        end
      end
      format.html do
        if current_user.buyer? || current_user.seller?
          @products = Product.where(store_id: params[:store_id]).kept.order(:title).includes(:store, image_attachment: :blob)
        else
          @products = Product.where(store_id: params[:store_id]).order(:title).includes(:store, image_attachment: :blob)
        end
      end
    end
  end

  # GET /stores/:store_id/products/:id
  def show
  end
  
  # GET /stores/:store_id/products/new
  def new
    @product = @store.products.build
  end
  
  # GET stores/:store_id/products/:id/edit
  def edit
  end

  # GET /listing
  def listing
    if !current_user.admin?
      redirect_to root_path, notice: "No permission for you!"
    end
    @products = Product.includes(:store)
  end

  # POST stores/:store_id/products
  def create
    @product = Product.new(product_params)

    if (@store.user == current_user && seller?) || current_user.admin?
      @product.store = @store
        
      if @product.save
        respond_to do |format|
          format.html { redirect_to [@store, @product], notice: 'Product was successfully created.' }
          format.json { render json: { product: @product }, status: :created }
        end
      else
        respond_to do |format|
          format.html { render :new }
          format.json { render json: { errors: @product.errors }, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT stores/:store_id/products/:id
  def update
    @product.undiscard if params.dig(:restore) && current_user.admin?

    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to store_product_url(@store, @product), notice: "Product was successfully updated." }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # DELETE stores/:store_id/products/:id
  def destroy
    @product.discard
    respond_to do |format|
      if @product.discarded?
        format.html { redirect_to store_products_url(@store, @product), notice: "Product was successfully destroyed." }
        format.json { render :show, status: :ok, location: @product}
      else
        format.html { redirect_to store_products_url(@store), alert: "Product can't be destroyed." }
        format.json { render json: { errors: @product.errors }, status: :unprocessable_entity }
      end
    end
  end

  private
  
  def set_store!
    @store = Store.find(params[:store_id])
  end

  def set_product!
    @product = @store.products.with_discarded.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:title, :description, :price, :image)
  end
end
