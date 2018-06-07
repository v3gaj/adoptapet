Rails.application.routes.draw do

  resources :sliders, :except => [:show]
  resources :categories, :except => [:show]
  devise_for :users, :controllers => {:registrations => "user/registrations"}

  resources :adoptions, :except => [:index, :show]

  get 'all_adoptions', to: 'adoptions#index'
  post 'all_adoptions', to: 'adoptions#index'

  resources :pets, :except => [:index, :profile, :adoptions, :requests] do 
      resources :posts
      resources :photos
  end

  resources :users, :except => [:new, :profile, :index]

  get 'add_five', to: 'posts#addFive'

  get 'all_users', to: 'users#index'
  post 'all_users', to: 'users#index'

  root 'index#home'

  get 'about', to: 'index#about'

  match "contact", to: "index#contact", :via => 'get'

  get 'my_profile', to: 'users#profile'

  get 'pet_profile', to: 'pets#profile'
  get 'pet_gallery', to: 'pets#gallery'
  post 'pet_paginate_available_pets', to: 'pets#paginate_available_pets'
  get 'pet_paginate_available_pets', to: 'pets#paginate_available_pets'
  post 'pet_filter_available_pets', to: 'pets#filter_available_pets'
  get 'pet_filter_available_pets', to: 'pets#filter_available_pets'
  post 'pet_filter_and_paginate_succesful_adoptions', to: 'pets#filter_and_paginate_succesful_adoptions'
  get 'pet_filter_and_paginate_succesful_adoptions', to: 'pets#filter_and_paginate_succesful_adoptions'

  post 'user_pets_for_adoption', to: 'users#pets_for_adoption'
  get 'user_pets_for_adoption', to: 'users#pets_for_adoption'
  post 'user_requests_for_pets', to: 'users#requests_for_pets'
  get 'user_requests_for_pets', to: 'users#requests_for_pets'
  post 'user_adopted_pets', to: 'users#adopted_pets'
  get 'user_adopted_pets', to: 'users#adopted_pets'


  get 'pets/adoption/available/', to: 'pets#index', as: 'pets_for_adoption'
  post 'pets/adoption/available/', to: 'pets#index'
  get 'pets/adoption/requests', to: 'pets#requests', as: 'adoption_requests'
  get 'pets/adoption/succesful', to: 'pets#adoptions', as: 'successful_adoptions'
  post 'pets/adoption/succesful', to: 'pets#adoptions'


  patch 'pet_delete', to: 'pets#delete'

  patch 'reject', to: 'adoptions#reject'

  get 'redirection_back', to: 'application#redirection_back'


  #Contact Mailer

  post 'contact', to: 'messages#create'

  #Error routes
  match '/404', to: 'errors#file_not_found', via: :all
  match '/422', to: 'errors#unprocessable', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all

  # Invalid routes
  get '*unmatched_route', to: 'errors#file_not_found'
end
