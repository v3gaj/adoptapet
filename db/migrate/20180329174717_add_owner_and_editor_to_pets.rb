class AddOwnerAndEditorToPets < ActiveRecord::Migration[5.1]
  def change
  	add_reference :pets, :owner
  	add_reference :pets, :editor
  end
end
