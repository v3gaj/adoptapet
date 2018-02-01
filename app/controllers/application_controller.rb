class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :categories_with_pets
  require 'will_paginate/array'

  def categories_with_pets
    @categ = Category.all.joins(:pets).uniq 
  end

  def require_user
    if !current_user
      flash[:danger] = "Para realizar esta acción se requiere iniciar sesión."
      redirect_to new_user_session_path
    end
  end

  def not_pet_user(pet_id)
    pet = Pet.find(pet_id)
    if current_user == pet.user
      flash[:danger] = "No puedes adoptar un mascota que pusiste en adopción."
      redirect_to pets_for_adoption_path 
    end
  end

  def pet_owner_editor
    if !Pet.owner_editor(@pet, current_user) && !current_user.admin?
      flash[:danger] = "Solo puedes editar tus propias mascotas."
      redirect_back fallback_location: pet_path(@pet)
    end
  end

  def require_admin
    if !current_user
      flash[:danger] = "Para realizar esta acción se requiere iniciar sesión."
      redirect_to new_user_session_path
    elsif current_user && !current_user.admin?
      flash[:danger] = "Solo los usuarios administradores pueden realizar esa acción."
      redirect_to my_profile_path
    end
  end

  def require_owner_or_admin(user_id, pet_id)
    pet = Pet.find(pet_id)
    if Pet.search_owner(pet) != current_user && user_id.to_i != current_user.id && !current_user.admin?
      redirect_back fallback_location: my_profile_path, notice: 'Solo puedes editar tus solicitudes de adopción'
    end
  end

  def require_same_user
    if current_user != @user and !current_user.admin?
      flash[:danger] = "Solo puedes editar tu propia cuenta."
      redirect_back fallback_location: root_path
    end
  end

  # DEVISE Redirect back after sign in

  before_action :store_user_location!, if: :storable_location?

  private

    def storable_location?
      request.get? && is_navigational_format? && !devise_controller? && !request.xhr? 
    end

    def store_user_location!
      # :user is the scope we are authenticating
      store_location_for(:user, request.fullpath)
    end

  protected

    def after_sign_in_path_for(resource)
      stored_location_for(:user) || super
    end

end
