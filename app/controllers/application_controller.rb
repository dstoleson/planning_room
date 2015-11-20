class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  before_filter :store_location
  before_filter :store_params

  helper_method :admin_user?

  def admin_user?
  	user = session["user"]
  	(not user.nil?) && (user["role"] == 'admin')
  end
  
  def session_expired
  end

  def store_location
    Rails.logger.debug "DEBUG: ENTER: store_location"
    Rails.logger.debug "DEBUG: request.path = #{request.path}"
    Rails.logger.debug "DEBUG: request.fullpath = #{request.fullpath}"
  	
    return unless request.get?
  	
    if (request.path != "/login") && (request.path != '/logout')
  		session[:previous_url] = request.fullpath
  	end
    Rails.logger.debug "DEBUG: previous_url = #{session[:previous_url]}"
  end

  def store_params
    Rails.logger.debug "DEBUG: ENTER: store_params"
  	return unless request.get?
    Rails.logger.debug "DEBUG: request.path = #{request.path}"

  	if (request.path != "/login")
      Rails.logger.debug "DEBUG: params = #{params}"
  		session[:previous_params] = params
  	end
    Rails.logger.debug "DEBUG: previous_params = #{session[:previous_params]}"
  end

  def after_sign_in_path_for(resource)
  	session[:previous_url] || root_path
  end

  def requires_admin
  	user = session[:user]
  	if user.nil? || user["role"] != 'admin'
  		redirect_to '/admin'
  	end
  end

  def requires_user
    user = session[:user]
  	if user.nil? || user["role"] != 'user'
  		redirect_to '/login'
  	end
  end

end
