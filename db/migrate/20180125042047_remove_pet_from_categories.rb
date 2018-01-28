class RemovePetFromCategories < ActiveRecord::Migration[5.1]
  def change
  	add_reference :pets, :category, foreign_key: true
  
  	remove_column :pets, :type
  end
end
