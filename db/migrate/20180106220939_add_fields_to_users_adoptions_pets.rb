class AddFieldsToUsersAdoptionsPets < ActiveRecord::Migration[5.1]
  def change
  	add_column :pets, :province, :string
  	add_column :pets, :city, :string
  	add_column :pets, :otherSigns, :text
  	remove_column :pets, :age
  	add_column :pets, :years, :integer
  	add_column :pets, :months, :integer
  	add_column :pets, :isDead, :boolean
  	add_column :pets, :deadReason, :text
  	add_column :pets, :delete, :boolean
  	add_column :users, :petsNumber, :integer
  	
  end
end
