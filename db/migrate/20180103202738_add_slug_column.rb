class AddSlugColumn < ActiveRecord::Migration[5.1]
  def change
  	add_column :users, :slug, :string
  	add_column :pets, :slug, :string
  end
end
