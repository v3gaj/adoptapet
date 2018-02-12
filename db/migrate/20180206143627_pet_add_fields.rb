class PetAddFields < ActiveRecord::Migration[5.1]
  def change
  	add_column :pets, :deleted, :boolean
  	add_column :pets, :facebook_id, :string
  	add_column :pets, :size, :string
  	remove_column :pets, :color
  end
end
