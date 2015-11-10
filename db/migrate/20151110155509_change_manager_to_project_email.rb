class ChangeManagerToProjectEmail < ActiveRecord::Migration
  def change
	rename_column :projects, :manager_email, :project_email
  end
end
