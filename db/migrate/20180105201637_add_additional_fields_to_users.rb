class AddAdditionalFieldsToUsers < ActiveRecord::Migration[5.1]
  def change
  	add_column :users, :name, :string
  	add_column :users, :lastName, :string
  	add_column :users, :province, :string
  	add_column :users, :city, :string
  	add_column :users, :otherSigns, :text
  	add_column :users, :phone, :string
  	add_attachment :users, :photo
  end
end
