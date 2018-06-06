class AddImageToSlider < ActiveRecord::Migration[5.1]
  def change
    add_attachment :sliders, :image
  end
end
