class SessionsController < ApplicationController

	protect_from_forgery

	def new
		# if session[:user_role] 
		# 	redirect_to projects_path
		# end
	end

	def create
		Rails.logger.debug "DEBUG: ENTER: create"
		@user = User.find_by_name(params[:session][:name])
		Rails.logger.debug "DEBUG: user = #{@user.name}, #{@user.role}"
		if @user
			session[:user] = @user
			Rails.logger.debug "DEBUG: user = #{session[:user]}"
			previous_url = session[:previous_url]
			session[:previous_url] = nil
			redirect_to previous_url
		else
			redirect_to '/login'
		end
	end

	def destroy 
	  session[:user] = nil 
	  redirect_to '/login' 
	end

end
