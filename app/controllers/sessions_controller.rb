class SessionsController < ApplicationController

	protect_from_forgery

	def new
		Rails.logger.debug "DEBUG: ENTER: SessionsController.new"
		Rails.logger.debug "DEBUG: params = #{params}"

		# if this was a request for a project, grab the id
		Rails.logger.debug "DEBUG: previous_path = #{session[:previous_url]}"
		Rails.logger.debug "DEBUG: previous_params = #{session[:previous_params]}"
		Rails.logger.debug "DEBUG: projects_path = #{projects_path}"
		if (not session[:previous_url].nil?) && 
			session[:previous_url].starts_with?(projects_path) && 
			(not session[:previous_params].nil?) &&
			(not session[:previous_params]["id"].nil?)

			session[:project_id] = session[:previous_params]["id"]
			@project = Project.find(session[:project_id])
			Rails.logger.debug "DEBUG: project_id = #{session[:project_id]}"
		end
	end

	def create
		Rails.logger.debug "DEBUG: ENTER: create"

		# don't look up user if a 'current' project
		user = User.find_by_name(params[:session][:name])

		if user
			Rails.logger.debug "DEBUG: user = #{user.name}, #{user.role}"
		end

		# if user exists and is an admin does not exist:
		#   1) check password for admin user
		#   2) if successful redirect to requested url		
		if user && user.admin? && user.authenticate(params[:session][:password])
			session[:user] = user

			# if session[:previous_url].nil?
				redirect_to projects_path
			# else
			# 	Rails.logger.debug "DEBUG: redirecting to #{session[:previous_url]}"
			# 	redirect_to session[:previous_url]
			# end
			return
		end

		# else		
		#   1) check password against the project being accessed
		#   2) if successful create a 'temp' user with a role of
		# 		user to be used for authorization and redirect to the
		#       project page
		#   3) if unsuccessful redirect to the project page (for another)
		#      authentication attempt
		project = Project.find(session[:project_id])
		Rails.logger.debug "DEBUG: project = #{project}"
		Rails.logger.debug "DEBUG: project.password = #{project.password}"
		Rails.logger.debug "DEBUG: password = #{params[:session][:password]}"
		if project && project.password == params[:session][:password]

			# current projects don't require a user for access, just the password
			# use a well-defined user for current projects
			# otherwise create a temp user for private projects

			# TODO: have a real 'default' user for 'current'
			user_name = "current_project_user"
			if not params[:session][:name].nil?
				user_name = params[:session][:name]
			end

			# TODO: have real 'default' user for 'private', update
			# user name to email after fetching
			user = User.new(name: user_name, role: 'user')
			session[:user] = user
			Rails.logger.debug "DEBUG: redirecting to #{session[:previous_url]}"
			redirect_to session[:previous_url]
			return
		end
		
		# decide whether to remove the previous_url from the session
		# or keep it as it can be used for multiple authentication attempts
		# session[:previous_url] = nil
		
		Rails.logger.debug "DEBUG: redirecting to /login"
		redirect_to '/login'
	end

	def destroy
		Rails.logger.debug "DEBUG: ENTER: destroy"		
		previous_url = session[:previous_url]
		Rails.logger.debug "DEBUG: previous_url = #{previous_url}"
		reset_session

		if not previous_url.nil?
			Rails.logger.debug "DEBUG: redirecting to #{previous_url}"
	  		redirect_to previous_url
	  	else
			Rails.logger.debug "DEBUG: redirecting to /login"
	  		redirect_to '/login'
	  	end
	end

end
