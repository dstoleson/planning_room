class AddBidDateToProject < ActiveRecord::Migration
  def change
    	add_column :projects, :bid_date, :datetime
  end
end
