json.extract! user, :id, :name, :lastName, :province, :city, :admin, :phone, :photo, :created_at, :updated_at
json.url user_url(user, format: :json)
