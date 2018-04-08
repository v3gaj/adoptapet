Rails.application.routes.draw do
  
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

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
