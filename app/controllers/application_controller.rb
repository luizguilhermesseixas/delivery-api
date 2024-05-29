class ApplicationController < ActionController::Base

  def current_user
    if request.format == Mime[:json]
      @user
    else
      super
    end
  end

  def authenticate!
    if request.format == Mime[:json]
      check_token!
    else
      authenticate_user!
    end
  end

  private

  def check_token!
    if user = authenticate_with_http_token { |t, _| User.from_token(t) }
      @user = User.new(id: user[:id], email: user[:email], role: user[:role])
    else
      render json: {message: "Not authorized"}, status: 401 
    end
  end

  def current_credential
    return nil if request.format != Mime[:json]

    Credential.find_by(key: request.headers["X-API-KEY"]) || Credential.new
  end

  def buyer?
    (current_user && current_user.buyer?) && current_credential.buyer?
  end

  def seller?
    (current_user && current_user.seller?) && current_credential.seller?
  end

  def only_buyers!
    is_buyer = (current_user && current_user.buyer?) && current_credential.buyer?
    
    if !is_buyer
      render json: {message: "Not authorized"}, status: 401
    end
  end

  def set_locale!
    if params[:locale].present?
      I18n.locale = params[:locale]
    end
  end
end