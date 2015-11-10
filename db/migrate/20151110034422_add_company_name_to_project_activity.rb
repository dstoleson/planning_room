class AddCompanyNameToProjectActivity < ActiveRecord::Migration
  def change
    	add_column :project_activities, :company_name, :string
  end
end
