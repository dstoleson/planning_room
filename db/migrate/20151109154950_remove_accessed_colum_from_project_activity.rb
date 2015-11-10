class RemoveAccessedColumFromProjectActivity < ActiveRecord::Migration
  def change
  	remove_column :project_activities, :accessed
  end
end
