class ChangeDeleteColumn < ActiveRecord::Migration[5.1]
  def change
  	remove_column :pets, :delete, :boolean
  	add_column :pets, :deletePet, :boolean
  end
end
