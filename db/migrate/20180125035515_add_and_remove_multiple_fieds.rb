class AddAndRemoveMultipleFieds < ActiveRecord::Migration[5.1]
  def change
  	
  	remove_column :pets, :otherSigns
  	remove_column :pets, :isDead
  	remove_column :pets, :deadReason
  	remove_column :pets, :deletePet
  	add_column :pets, :show, :boolean
  	remove_column :photos, :title
  	remove_column :users, :petsNumber
  	remove_column :users, :otherSigns
  end
end
