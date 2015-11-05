class SessionsController < ApplicationController

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
			session[:user_role] = @user.role
			Rails.logger.debug "DEBUG: user_role = #{session[:user_role]}"
			redirect_to session[:previous_url]
		else
			redirect_to '/login'
		end
	end

	def destroy 
	  session[:user_role] = nil 
	  redirect_to '/login' 
	end

end
