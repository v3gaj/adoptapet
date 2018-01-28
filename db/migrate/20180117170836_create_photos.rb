class CreatePhotos < ActiveRecord::Migration[5.1]
  def change
    create_table :photos do |t|
      t.attachment :photo
      t.string :title

      t.timestamps
    end
  end
end
