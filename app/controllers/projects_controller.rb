class ProjectsController < ApplicationController

	before_action :requires_user, only: [:show]
	before_action :requires_admin, only: [:new, :create, :edit, :update, :destroy]

	def index
		Rails.logger.debug 'DEBUG: enter index'
		if admin_user?
			@projects = Project.order(name: :asc)
		else
			reset_session
			@projects = Project.joins(:project_type).where(project_types: {name: "open"}).order(name: :asc)
		end
	end

	def new
		@project = Project.new		
		@button_title = "Create Project"
		@title = "New Project"
	end

	def create
		Rails.logger.debug 'DEBUG: enter create'
		@project = Project.new(project_params)
		if @project.save
			redirect_to projects_path, :notice => "Project: #{@project.name}, created."			
		end			
		@button_title = "Create Project"
		@title = "New Project"
	end

	def edit
		@project = Project.find(params[:id])		
		project_activities
		@button_title = "Update Project"
		@title = "Edit Project"
	end

	def update
		@project = Project.find(params[:id])
		if @project.update(project_params)
			redirect_to projects_path, :notice => "Project: #{@project.name}, updated."			
			return
		end				
		project_activities

		@button_title = "Update Project"
		@title = "Edit Project"
	end

	def show
		Rails.logger.debug 'DEBUG: enter show'
		@project = Project.find(params[:id])		

		if admin_user?
			redirect_to edit_project_path @project
		end
	end

	private

	def project_params
		Rails.logger.debug("DEBUG: params = #{params}")
    	params.require(:project).permit(:name, 
    		:project_type,
    		:password,
    		:password_confirmation,
    		:bid_date,
    		:dropbox_url,
    		:manager_name,
    		:project_email,
    		:project_type_id)
  	end

  	def project_activities
		@sorted_project_activities = @project.project_activities.order("to_char(created_at, 'YYYYMMDD') DESC", email: :asc)
		@sorted_project_email = @project.project_activities.order(email: :asc)
	end	
end


