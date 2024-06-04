class StoresController < ApplicationController
  skip_forgery_protection only: [:create, :update, :destroy]
  before_action :authenticate!
  before_action :set_store, only: %i[ show edit update destroy ]

  # GET /stores or /stores.json
  def index
    if current_user.admin?
      @stores = Store.includes(:user).all
    else
      @stores = Store.kept.where(user: current_user).includes(:user)
    end
  end

  # GET /stores/1 or /stores/1.json
  def show
  end

  # GET /stores/new
  def new
    @store = Store.new
    if current_user.admin?
      @sellers = User.where(role: :seller)
    end
  end

  # GET /stores/1/edit
  def edit
    if current_user.admin?
      @sellers = User.where(role: :seller)
    end
  end

  # POST /stores or /stores.json
  def create
    @store = Store.new(store_params)
    
    if !current_user.admin?
      @store.user = current_user
    end

    respond_to do |format|
      if @store.save
        format.html { redirect_to store_url(@store), notice: "Store was successfully created." }
        format.json { render :show, status: :created, location: @store }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stores/1 or /stores/1.json
  def update
    @store.undiscard if params.dig(:restore)

    respond_to do |format|
      if @store.update(store_params)
        format.html { redirect_to store_url(@store), notice: "Store was successfully updated." }
        format.json { render :show, status: :ok, location: @store }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stores/1 or /stores/1.json
def destroy
    respond_to do |format|
      if @store.discard
        format.html { redirect_to stores_url, notice: "Store was successfully destroyed." }
        format.json { render json: { message: "Store was successfully destroyed." }, status: :ok }
      else
        format.html { redirect_to stores_url, alert: "Store could not be destroyed." }
        format.json { head :unprocessable_entity }
      end
    end
  end
  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_store
      @store = Store.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def store_params
      required = params.require(:store)
      
      if current_user.admin?
        required.permit(:name, :user_id)
      else
        required.permit(:name)
      end
    end
end
