json.extract! pet, :id, :name, :photo, :category_id, :show, :cover, :size, :deleted, :gender, :years, :months, :province, :city, :priority, :description, :user_id, :created_at, :updated_at
json.url pet_url(pet, format: :json)
