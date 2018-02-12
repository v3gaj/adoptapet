class IndexController < ApplicationController
  def home
  	@pets = Pet.all.where('pets.deleted = ? AND (pets.id NOT IN (?) OR pets.id IN (?))', false, (Adoption.all.select(:pet_id).where("adoptions.status <> ? AND adoptions.status <> ?", 'created', 'returned')), 
            (Adoption.all.select(:pet_id).where("adoptions.status = ? AND adoptions.pet_id NOT IN (?)", 'rejected', (Adoption.all.select(:pet_id).where("adoptions.status = ?", 'accepted'))))).order(created_at: :desc).limit(9)
  end

  def about
  end

  def contact
  end
end
