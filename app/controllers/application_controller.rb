class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :session_expired
  before_filter :store_location
  before_filter :store_params

  helper_method :admin_user?

  def admin_user?
	Rails.logger.debug "DEBUG: ENTER: admin_user?"
  	user = session["user"]
	Rails.logger.debug "DEBUG: user = #{user.inspect}"
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
		Rails.logger.debug "DEBUG: previous_url = #{session[:previous_url]}"
  	end
  end

  def store_params
	Rails.logger.debug "DEBUG: ENTER: store_params"
  	Rails.logger.debug "DEBUG: params = #{params}"
  	return unless request.get?
  	if (request.path != "/login")
  		session[:previous_params] = params
  	end
  end

  def after_sign_in_path_for(resource)
	Rails.logger.debug "DEBUG: ENTER: after_sign_in_path_for"
  	session[:previous_url] || root_path
  end

  def requires_admin
	Rails.logger.debug "DEBUG: ENTER: requires_admin"
	user = session[:user]
	Rails.logger.debug "DEBUG: user = #{user.inspect}"
  	if user.nil? || user["role"] != 'admin'
  		redirect_to '/login'
  	end
  end

  def requires_user
	Rails.logger.debug "DEBUG: ENTER: requires_user"
	user = session[:user]
	Rails.logger.debug "DEBUG: user = #{user.inspect}"
  	if user.nil? || user["role"] != 'user'
  		redirect_to '/login'
  	end
  end

  def requires_login
  	if session[:user].nil?
  		redirect_to '/login'
  	end
  end

end
