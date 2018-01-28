class AddPriorityToPets < ActiveRecord::Migration[5.1]
  def change
  	add_column :pets, :priority, :string
  end
end
