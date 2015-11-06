class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :store_location

  helper_method :admin_user?

  def admin_user?
	Rails.logger.debug "DEBUG: ENTER: admin_user?"
  	user = session["user"]
	Rails.logger.debug "DEBUG: user = #{user}"
  	(not user.nil?) && user["role"] == 'admin'
  end
  
  def store_location
	Rails.logger.debug "DEBUG: ENTER: store_location"
  	Rails.logger.debug "DEBUG: request.path = #{request.path}"
	Rails.logger.debug "DEBUG: request.fullpath = #{request.fullpath}"
  	return unless request.get?
  	if (request.path != "/login") || (not session[:user].nil?)
  		session[:previous_url] = request.fullpath
  	end
  end

  def after_sign_in_path_for(resource)
	Rails.logger.debug "DEBUG: ENTER: after_sign_in_path_for"
  	session[:previous_url] || root_path
  end

  def requires_admin
	Rails.logger.debug "DEBUG: ENTER: requires_admin"
	user = session[:user]
	Rails.logger.debug "DEBUG: user = #{user}"
	unless user.nil? 
		Rails.logger.debug "DEBUG: user.role = #{user["role"]}" 
	end
  	if user.nil? || user["role"] != 'admin'
  		redirect_to '/login'
  	end
  end

  def requires_user
	Rails.logger.debug "DEBUG: ENTER: requires_user"
	user = session[:user]
	Rails.logger.debug "DEBUG: user = #{user}"
	unless user.nil? 
		Rails.logger.debug "DEBUG: user = #{user["role"]}" 
	end
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
