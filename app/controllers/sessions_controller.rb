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
		Rails.logger.debug "DEBUG: email = #{params[:session][:name]}"
		Rails.logger.debug "DEBUG: company_name = #{params[:session][:company_name]}"
		Rails.logger.debug "DEBUG: password = #{params[:session][:password]}"

		session[:initial_url] = session[:previous_url]
		Rails.logger.debug "DEBUG: session[:initial_url] = #{session[:initial_url]}"

		email_regex = /\A[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}\z/i

		# always require an email address
		if not (params[:session] && params[:session][:name] && (email_regex =~ params[:session][:name]))
			flash[:notice] = "Enter a valid email address."
			redirect_to session[:initial_url]
			return
		end

		if session[:project_id]
			project_type = 'open'

			# require company name
			if params[:session].nil? || params[:session][:company_name].nil? || params[:session][:company_name] == ""
				flash[:notice] = "Enter a company name."
				redirect_to session[:initial_url]
				return
			end

			# if there is a :project_id a password is not required
			# todo: check that it is a open project(?)
			project = Project.joins(:project_type).where(id: session[:project_id], project_types: {name: project_type})

		else
			# if private, require a company name
			if (session[:initial_url] == "/private")
				project_type = 'private'
				if (params[:session].nil? || params[:session][:company_name].nil? || params[:session][:company_name] == "")
					flash[:notice] = "Enter a company name."
					redirect_to session[:initial_url]
					return
				end
			else
				project_type = 'current'
			end

			# find the project that matches the password parameter
			project = Project.joins(:project_type).where(password: params[:session][:password], project_types: {name: project_type})
		end

		Rails.logger.debug "DEBUG: project = #{project}"

		if project && project[0]

			# create a 'temp' user with role of 'user' to be use for authorization
			# during the session
			user = User.new(name: params[:session][:name], role: 'user')
			session[:user] = user

			Rails.logger.debug "DEBUG: email = #{params[:session][:name]}"
			Rails.logger.debug "DEBUG: password = #{params[:session][:company_name]}"

			# insert activity tracking record
			project_activity = ProjectActivity.new()
			project_activity.project = project[0]
			project_activity.email = params[:session][:name]
			project_activity.company_name = params[:session][:company_name]
			project_activity.save

			redirect_to project[0]
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
				# redirect_url = session[:initial_url]
				redirect_to = '/'
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
