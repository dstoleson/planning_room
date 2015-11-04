class CreateProjectActivity < ActiveRecord::Migration
  def change
    create_table :project_activities do |t|
    	t.belongs_to :project, index: true
    	t.string :email
    	t.date :accessed
    end
  end
end
