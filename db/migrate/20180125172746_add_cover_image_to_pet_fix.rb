class AddCoverImageToPetFix < ActiveRecord::Migration[5.1]
  def change
  	
  	add_attachment :pets, :cover
  end
end
