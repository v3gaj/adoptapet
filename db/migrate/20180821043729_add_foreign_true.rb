class AddForeignTrue < ActiveRecord::Migration[5.1]
  def change
  	remove_column :photos, :post_id
  	add_reference :photos, :post, foreign_key: true
  end
end
