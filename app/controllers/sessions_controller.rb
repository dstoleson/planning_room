class SessionsController < ApplicationController

	protect_from_forgery

	def new

		Rails.logger.debug "DEBUG: ENTER: new"
		Rails.logger.debug "DEBUG: previous_params = #{session[:previous_params]}"	
		Rails.logger.debug "DEBUG: request.path = #{request.path}"

		if not session[:user].nil?
			reset_session
		end

		# if the initial URL contained a project 'id' parameter
		# show the project
		if session[:previous_params] && session[:previous_params]["id"]
			project_id = session[:previous_params]["id"]
			Rails.logger.debug "DEBUG: project_id = #{project_id}"
			session[:project_id] = project_id
			Rails.logger.debug "DEBUG: session[:project_id] = #{session[:project_id]}"
			@project = Project.find(project_id)
		end

		@show_company_name = false
		@show_password = false

		@show_company_name = (@project || request.path == '/private')
		@show_password = (not @project)

		Rails.logger.debug "DEBUG: show_company_name = #{@show_company_name}"
		Rails.logger.debug "DEBUG: show_password = #{@show_password}"

	end

	def create
		Rails.logger.debug "DEBUG: ENTER: create"
		Rails.logger.debug "DEBUG: session[:project_id] = #{session[:project_id]}"
		Rails.logger.debug "DEBUG: password = #{params[:session][:password]}"

		session[:initial_url] = session[:previous_url]
		Rails.logger.debug "DEBUG: session[:initial_url] = #{session[:initial_url]}"

		if session[:project_id]
			# if there is a :project_id a password is not required
			# todo: check that it is a open project(?)
			project = Project.find(session[:project_id])
		else
			# find the project that matches the password parameter
			project = Project.find_by_password(params[:session][:password])
		end

		Rails.logger.debug "DEBUG: project = #{project}"

		if project
			# create a 'temp' user with role of 'user' to be use for authorization
			# during the session
			user = User.new(name: params[:session][:name], role: 'user')
			session[:user] = user

			Rails.logger.debug "DEBUG: email = #{params[:session][:name]}"
			Rails.logger.debug "DEBUG: password = #{params[:session][:company_name]}"

			# insert activity tracking record
			project_activity = ProjectActivity.new()
			project_activity.project = project
			project_activity.email = params[:session][:name]
			project_activity.company_name = params[:session][:company_name]
			project_activity.save

			redirect_to project 
			return
		else
			flash[:notice] = "Project password was invalid."
			redirect_to session[:initial_url]
			return
		end
	end

	def destroy
		Rails.logger.debug "DEBUG: ENTER: destroy"		
		
		redirect_url = nil

		if admin_user?
			redirect_url = '/admin_logout'			
		else
			if session[:project_id]
				redirect_url = '/open'
			elsif session[:initial_url]
				redirect_url = session[:initial_url]
			end
		end
		reset_session

		if redirect_url
			redirect_to redirect_url
		else
			redirect_to '/'
		end
	end

end
