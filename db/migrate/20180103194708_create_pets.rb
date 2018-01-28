class CreatePets < ActiveRecord::Migration[5.1]
  def change
    create_table :pets do |t|
      t.string :name
      t.string :photo
      t.string :type
      t.string :color
      t.string :gender
      t.string :age
      t.text :description
      t.boolean :adopted
      t.references :user, foreign_key: true
      t.references :adopter
      
      t.timestamps
    end
  end
end
