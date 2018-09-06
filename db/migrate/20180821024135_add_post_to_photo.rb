class AddPostToPhoto < ActiveRecord::Migration[5.1]
  def change
  	add_reference :photos, :post
  	remove_column :posts, :photo_id
  end
end
