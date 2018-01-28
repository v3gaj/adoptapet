class CreateAdoptions < ActiveRecord::Migration[5.1]
  def change
    create_table :adoptions do |t|
      t.references :user, foreign_key: true
      t.string :status
      t.text :comments
      t.text :rejectReason
      t.belongs_to :animal, class: 'Pet'
      t.timestamps
    end
  end
end
