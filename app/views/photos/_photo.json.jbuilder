json.extract! photo, :id, :photo, :title, :created_at, :updated_at
json.url photo_url(photo, format: :json)
