class ProjectsController < ApplicationController

	before_action :requires_login, only: [:show]
	before_action :requires_admin, only: [:index, :new, :create, :edit, :update, :destroy]

	def index
		Rails.logger.debug "DEBUG: session = #{session}"
		project_type_name = params[:project_type_name]
		if project_type_name.nil?
			@projects = Project.all
		else
			@projects = Project.joins(:project_type).where(project_types: {name: project_type_name})
		end
		Rails.logger.debug "DEBUG: projects = #{@projects}"
		@projects.each do |project|
			Rails.logger.debug "DEBUG: project = #{project.name}"
		end			
	end

	def new
		@project = Project.new		
	end

	def create
		Rails.logger.debug 'DEBUG: enter create'
		@project = Project.new(project_params)
		Rails.logger.debug "DEBUG: project = |#{@project.name}|#{@project.project_type}|#{@project.password}|#{@project.dropbox_url}|#{@project.manager_name}|#{@project.manager_email}|"
		if @project.save
			redirect_to projects_path, :notice => "Project: #{@project.name}, created."			
		else
			render :new
		end			
	end

	def edit
		@project = Project.find(params[:id])
		Rails.logger.debug "DEBUG: project_types = #{@project_types}"		
		Rails.logger.debug "DEBUG: project = |#{@project.name}|#{@project.project_type}|#{@project.password}|#{@project.dropbox_url}|#{@project.manager_name}|#{@project.manager_email}|"
	end

	def update
		Rails.logger.debug 'DEBUG: enter update'
		@project = Project.find(params[:id])
		Rails.logger.debug "DEBUG: project = |#{@project.name}|#{@project.project_type}|#{@project.password}|#{@project.dropbox_url}|#{@project.manager_name}|#{@project.manager_email}|"
		if @project.update!(project_params)
			Rails.logger.debug "DEBUG: project = |#{@project.name}|#{@project.project_type}|#{@project.password}|#{@project.dropbox_url}|#{@project.manager_name}|#{@project.manager_email}|"
			redirect_to projects_path, :notice => "Project: #{@project.name}, updated."			
		else
			redirect_to projects_path, :notice => "Unabled to update project: #{@project.name}."			
		end				
	end

	def show
		@project = Project.find(params[:id])		
		# insert activity tracking record
		project_activity = ProjectActivity.new()
		project_activity.project = @project
		project_activity.email = session[:user][:name]
		project_activity.save
		Rails.logger.debug("DEBUG: project_activity = #{project_activity}")
		Rails.logger.debug "DEBUG: project = |#{@project.name}|#{@project.project_type}|#{@project.password}|#{@project.dropbox_url}|#{@project.manager_name}|#{@project.manager_email}|"
	end

	def destroy
		project = Project.find(params[:id])
		project.destroy
		redirect_to projects_path, :notice => "Project: #{@project.name}, deleted."
	end

	private

	def project_params
    	params.require(:project).permit(:name, 
    		:project_type,
    		:password,
    		:dropbox_url,
    		:manager_name,
    		:manager_email,
    		:project_type_id)
  	end

end


