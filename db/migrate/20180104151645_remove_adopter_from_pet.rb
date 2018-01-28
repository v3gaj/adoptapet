class RemoveAdopterFromPet < ActiveRecord::Migration[5.1]
  def change
  	remove_column :pets, :adopted
  	remove_column :pets, :adopter_id
  end
end
