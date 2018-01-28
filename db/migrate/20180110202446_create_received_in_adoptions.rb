class CreateReceivedInAdoptions < ActiveRecord::Migration[5.1]
  def change
    remove_column :pets, :delivered
    remove_column :adoptions, :received
  	add_column :adoptions, :received, :boolean
  end
end
