class IndexController < ApplicationController
  def home
    @sliders = Slider.all
    @pets = Pet.all.where('(pets.owner_id IS NULL OR 
                               pets.id IN (?)) AND 
                               pets.deleted = ?', 
                               (Adoption.all.select(:pet_id).where('adoptions.status = ?', 'returned')), 
                               false).limit(9).order("RAND()")
  end

  def about
  end

  def contact
    @message = Message.new
  end
end
