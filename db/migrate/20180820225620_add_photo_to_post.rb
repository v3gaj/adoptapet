class AddPhotoToPost < ActiveRecord::Migration[5.1]
  def change
  	add_reference :posts, :photo
  end
end
