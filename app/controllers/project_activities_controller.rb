class ProjectActivitiesController < ApplicationController
	
	def new
		@project_activity = ProjectActivity.new
		project_id = params[:project_id]

		unless project_id.nil?
			@project = Project.find(project_id)
		end
	end

	def create
		@project_activity = ProjectActivity.new()
		project_id = params[:project_id]

		unless project_id.nil?
			@project = Project.find(project_id)
		end		

		@project_activity.project = @project
		@project_activity.email = 'dstoleson@mac.com'
		@project_activity.accessed = DateTime.now

		@project_activity.save

		redirect_to @project 
	end

end