class IncludePhotoAsAttachment < ActiveRecord::Migration[5.1]
  def change
  	remove_column :pets, :photo, :string
  	add_attachment :pets, :photo
  end
end
