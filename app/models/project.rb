class Project < ActiveRecord::Base

	belongs_to :project_type, :foreign_key => :project_type_id
	has_many :project_activities

	validates_presence_of :name, :message => "Project Name cannot be empty."
	validates_presence_of :project_type, :message => "A Project Type must be selected."
	validates_presence_of :password, :message => "Password cannot be empty."
	validates_confirmation_of :password, :message => "Confirmation doesn't match password."
	validates_presence_of :dropbox_url, :message => "Dropbox URL cannot be empty."
	validates_presence_of :manager_name, :message => "Project Manager cannot be empty."
	validates_presence_of :project_email, :message => "Submit Bid Email cannot be empty."

	validates_format_of :project_email, with: /\A[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}\z/i, :message => "Submit Bid Email must be a valid email address."
	validates_format_of :dropbox_url, with: /https?:\/\/[\S]+/, :message => "Dropbox URL must be a valid URL."

	def bid_date_display
		if not bid_date.nil?
			return bid_date.strftime("%m/%d/%Y")
		end
	end
end