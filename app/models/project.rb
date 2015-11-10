class Project < ActiveRecord::Base

	belongs_to :project_type, :foreign_key => :project_type_id
	has_many :project_activities

	validates_presence_of :name
	validates_presence_of :project_type
	validates_presence_of :password
	validates_presence_of :dropbox_url
	validates_presence_of :manager_name
	validates_presence_of :manager_email

	validates_format_of :manager_email, with: /\A[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}\z/i
	validates_format_of :dropbox_url, with: /https?:\/\/[\S]+/

	def bid_date_display
		if not bid_date.nil?
			return bid_date.strftime("%m/%d/%Y")
		end
	end
end