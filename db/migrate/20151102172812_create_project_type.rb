class CreateProjectType < ActiveRecord::Migration
  def change
    create_table :project_types do |t|
     	t.string :name
      	t.string :description
    end
  end
end
