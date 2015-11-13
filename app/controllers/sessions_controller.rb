class SessionsController < ApplicationController

	protect_from_forgery

	def new
		Rails.logger.debug "DEBUG: ENTER: new"
		Rails.logger.debug "DEBUG: previous_params = #{session[:previous_params]}"	

		if session[:previous_params] && session[:previous_params]["id"]
			project_id = session[:previous_params]["id"]
			Rails.logger.debug "DEBUG: project_id = #{project_id}"
			session[:project_id] = project_id
			Rails.logger.debug "DEBUG: session[:project_id] = #{session[:project_id]}"
			@project = Project.find(project_id)
		end
	end

	def create
		Rails.logger.debug "DEBUG: ENTER: create"
		Rails.logger.debug "DEBUG: session[:project_id] = #{session[:project_id]}"

		#   1) check password against the project being accessed
		#   2) if successful create a 'temp' user with a role of
		# 		user to be used for authorization and redirect to the
		#       project page
		#   3) if unsuccessful redirect to the project page (for another)
		#      authentication attempt
		project = Project.find(session[:project_id])

		Rails.logger.debug "DEBUG: project = #{project}"
		Rails.logger.debug "DEBUG: password = #{params[:session][:password]}"

		# if there is a project and it is not 'open' a password is require
		if project && (project.project_type.name == 'open' || project.password == params[:session][:password])
			# TODO: have real 'default' user for project logins, update
			# user name to email after fetching
			user = User.new(name: params[:session][:name], role: 'user')
			session[:user] = user

			Rails.logger.debug "DEBUG: password = #{params[:session][:company_name]}"

			# insert activity tracking record
			project_activity = ProjectActivity.new()
			project_activity.project = project
			project_activity.email = params[:session][:name]
			project_activity.company_name = params[:session][:company_name]
			project_activity.save

			Rails.logger.debug("DEBUG: project_activity = #{project_activity.inspect}")
			Rails.logger.debug "DEBUG: project = #{@project.inspect}"
			Rails.logger.debug "DEBUG: redirecting to #{session[:previous_url]}"
			redirect_to session[:previous_url]
			return
		else
			flash[:notice] = "Project password was invalid."
			redirect_to project
			return
		end
	end

	def destroy
		Rails.logger.debug "DEBUG: ENTER: destroy"		
		
		if admin_user?
			redirect_to '/admin_logout'
			return
		end

		project = Project.find(session[:project_id])
		reset_session
		redirect_to project
	end

end
