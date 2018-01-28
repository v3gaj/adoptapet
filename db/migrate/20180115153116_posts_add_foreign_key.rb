class PostsAddForeignKey < ActiveRecord::Migration[5.1]
  def change
  	remove_column :posts, :pet_id
  	add_reference :posts, :pet, foreign_key: true
  end
end
