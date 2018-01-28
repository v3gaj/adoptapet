class ChangeAnimalIdByPetId < ActiveRecord::Migration[5.1]
  def change
  	remove_column :adoptions, :animal_id
  	add_reference :adoptions, :pet
  end
end
