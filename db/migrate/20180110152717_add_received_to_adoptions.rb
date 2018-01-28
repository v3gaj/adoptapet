class AddReceivedToAdoptions < ActiveRecord::Migration[5.1]
  def change
  	add_column :adoptions, :received, :boolean
  end
end
