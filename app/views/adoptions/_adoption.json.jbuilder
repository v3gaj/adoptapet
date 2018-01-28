json.extract! adoption, :id, :user_id, :pet_id, :status, :rejectReason,  :comments, :created_at, :updated_at
json.url adoption_url(adoption, format: :json)
