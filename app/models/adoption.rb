class Adoption < ApplicationRecord

  # RELATIONS #

  belongs_to :user
  belongs_to :animal, :class_name => 'Pet', :foreign_key => 'pet_id'


  # VALIDATIONS #

  validates :status, presence: true 
  validates :comments, presence: true, :on => :create
  validates :rejectReason, presence: true, :on => :reject

  # METHODS #

  def self.get_adoption_comments(user, pet)
    adoption = Adoption.where(user: user, animal: pet).first
    return adoption.comments
  end

  def self.get_adoption_reject_reasons(user, pet)
    adoption = Adoption.where(user: user, animal: pet).first
    return adoption.rejectReason
  end

  def self.adoption_already_exists(user, pet)
    Adoption.where(user: user, animal: pet).exists?
  end

  def self.adoption_not_incomplete_exists(user, pet)
    Adoption.where(user: user, animal: pet).where.not(status: 'incomplete').exists?
  end

  def self.adoption_status(user, pet, status)
    Adoption.where(status: status, user: user, animal: pet).exists?
  end

  def self.adoption_status_exists(pet, status)
    Adoption.where(status: status, animal: pet).exists?
  end

  def self.adoption_received(user, pet)
    Adoption.where(received: true, user: user, animal: pet).exists?
  end

  def self.adoption_received_exists(pet, status)
    Adoption.where(received: true, status: status, animal: pet).exists?
  end

  def self.adoption_received_returned?(user, pet)
    Adoption.adoption_received(user, pet) && Adoption.adoption_status(user, pet, "returned") ? true : false
  end

  def self.adoption_accepted_received?(user, pet)
    Adoption.adoption_status(user, pet, "accepted") && Adoption.adoption_received(user, pet) ? true : false
  end

  def self.adoption_accepted_not_received?(user, pet)
    Adoption.adoption_status(user, pet, "accepted") && !Adoption.adoption_received(user, pet) ? true : false
  end

  def self.adoption_not_received(pet)
    (Adoption.adoption_received_exists(pet, "accepted") || 
    Adoption.adoption_received_exists(pet, "returned")) ? false : true
  end

  # Only allow to elimnate not recived pets

  def self.delete_pet(pet, user)
    Adoption.adoption_not_received(pet) && 
    Pet.equals_current_user?(pet, user) ? true : false
  end

  # Only allow to elimnate not received pets by admins

  def self.delete_by_admin(pet, user)
    Adoption.adoption_not_received(pet) && user.admin? ? true : false
  end

  # def self.adoption_exists?(pet)
  #   Adoption.where(animal: pet).exists?
  # end

  # def self.adoption_already_exists?(current_user, pet)
  #   Adoption.where(user: current_user, animal: pet).exists?
  # end

  # def self.adoption_returned?(current_user, pet)
  #   adoption = Adoption.where(user: current_user, animal: pet).first
  #   if adoption != nil && adoption.status === 'returned'
  #     return true
  #   end
  # end

  

  # def self.adoption_status(user, pet)
  #   adoption = Adoption.where(user: user, animal: pet).first
  #   return adoption.status
  # end

  # def self.adoption_accepted?(pet)
  #   Adoption.where(status: 'accepted', animal: pet).exists?
  # end

  # def self.adoption_accepted_user(pet)
  #   adoption = Adoption.where(status: 'accepted', animal: pet).first
  #   return adoption.user_id
  # end

  # def self.adoption_received?(pet)
  #   adoption = Adoption.select(:received).where(status: 'accepted', animal: pet).first
  #   return adoption.received
  # end
end
