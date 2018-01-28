class AddPetIndexToPosts < ActiveRecord::Migration[5.1]
  def change
  	add_reference :posts, :pet
  end
end
