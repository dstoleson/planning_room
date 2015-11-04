class CreateProjects < ActiveRecord::Migration
    def change
        create_table :projects do |t|
        	t.belongs_to :project_type, index:true
    	   	t.string :name
        	t.string :password
        	t.string :dropbox_url
        	t.string :manager_name
        	t.string :manager_email
        end
    end
end
