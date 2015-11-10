class ProjectsController < ApplicationController

	before_action :requires_login, only: [:show]
	before_action :requires_admin, only: [:new, :create, :edit, :update, :destroy]

	def index
		Rails.logger.debug "DEBUG: session = #{session}"
		if admin_user?
			@projects = Project.all
		else
			@projects = Project.joins(:project_type).where(project_types: {name: "open"})
		end
		Rails.logger.debug "DEBUG: projects = #{@projects}"
		@projects.each do |project|
			Rails.logger.debug "DEBUG: project = #{project.inspect}"
		end			
	end

	def new
		@project = Project.new		
	end

	def create
		Rails.logger.debug 'DEBUG: enter create'
		@project = Project.new(project_params)
			Rails.logger.debug "DEBUG: project = #{@project.inspect}"
		if @project.save
			redirect_to projects_path, :notice => "Project: #{@project.name}, created."			
		else
			render :new
		end			
	end

	def edit
		@project = Project.find(params[:id])
	end

	def update
		Rails.logger.debug 'DEBUG: enter update'
		@project = Project.find(params[:id])
			Rails.logger.debug "DEBUG: project = #{@project.inspect}"
		if @project.update!(project_params)
			Rails.logger.debug "DEBUG: project = #{@project.inspect}"
			redirect_to projects_path, :notice => "Project: #{@project.name}, updated."			
		else
			redirect_to projects_path, :notice => "Unabled to update project: #{@project.name}."			
		end				
	end

	def show
		@project = Project.find(params[:id])		
	end

	def destroy
		project = Project.find(params[:id])
		project.destroy
		redirect_to projects_path, :notice => "Project: #{@project.name}, deleted."
	end

	private

	def project_params
		Rails.logger.debug("DEBUG: params = #{params}")
    	params.require(:project).permit(:name, 
    		:project_type,
    		:password,
    		:bid_date,
    		:dropbox_url,
    		:manager_name,
    		:project_email,
    		:project_type_id)
  	end

end


