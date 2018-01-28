class PhotosAddForeignKeyPet < ActiveRecord::Migration[5.1]
  def change
  	add_reference :photos, :pet, foreign_key: true
  end
end
