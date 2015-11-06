class AddTimestampsToProjectActivity < ActiveRecord::Migration
  def change
      add_column :project_activities, :created_at, :datetime
      add_column :project_activities, :updated_at, :datetime
  end
end
