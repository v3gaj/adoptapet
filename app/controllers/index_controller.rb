class IndexController < ApplicationController
  def home
  	@pets = Pet.all.where('pets.id NOT IN (?) or pets.id IN (?)', (Adoption.all.select(:pet_id).where("adoptions.status <> ? AND adoptions.status <> ?", 'created', 'returned')), 
            (Adoption.all.select(:pet_id).where("adoptions.status = ? AND adoptions.pet_id NOT IN (?)", 'rejected', (Adoption.all.select(:pet_id).where("adoptions.status = ?", 'accepted'))))).order(created_at: :desc).limit(9)
  end

  def about
  	
  	#@graph.get_connection(100001156528021, 'feed')
  	#@graph.put_connections(100001156528021, 'feed', :message => 'message')
  	fcsdcsd
  	#@graph.put_wall_post(message: 'post on page wall')
  	#page = @graph.get_page_access_token(1930291580543046)
  end

  def contact
  end
end
