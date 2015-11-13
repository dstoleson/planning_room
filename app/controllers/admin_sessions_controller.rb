class AdminSessionsController < ApplicationController

	protect_from_forgery

	def new
	end

	def create
		Rails.logger.debug "DEBUG: ENTER: create"

		user = User.find_by_name(params[:session][:name])

		Rails.logger.debug "DEBUG: user = #{user.inspect}"

		if user && user.admin? && user.authenticate(params[:session][:password])
			session[:user] = user
			redirect_to projects_path
		else
			flash[:notice] = "Username or password was invalid."
			redirect_to '/admin'
		end
	end

	def destroy
		reset_session
		redirect_to '/admin'
	end
end