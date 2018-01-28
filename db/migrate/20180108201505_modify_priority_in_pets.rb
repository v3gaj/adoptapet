class ModifyPriorityInPets < ActiveRecord::Migration[5.1]
  def change
  	add_column :pets, :delivered, :boolean 
  end
end
