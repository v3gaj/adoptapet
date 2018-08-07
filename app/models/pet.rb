class Pet < ApplicationRecord

	# FRIENDLY ID #

  extend FriendlyId
  friendly_id :pet_name, use: :slugged

  def pet_name
		[
			[:name, :sequence],
		]
  end

  def sequence
    slug = normalize_friendly_id(name)
    sequence = Pet.where("slug LIKE :prefix", prefix: "#{slug}%").count
    sequence > 0 ? "-#{sequence}" : nil
  end


  # VALIDATIONS #

  validates :name, presence: true
  validates :size, presence: true
  validates :gender, presence: true
  validates :description, presence: true
  validates :province, presence: true
  validates :city, presence: true
  validates :priority, presence: true

  has_attached_file :photo, styles: { thumb: "100x100#", large: "490x490#", wide: "558x400#"}, convert_options: { thumb: "-quality 30", large: "-quality 30", wide: "-quality 50" }
	validates_attachment :photo, presence: true, size: { in: 0..6.megabytes }
	validates_attachment_content_type :photo, content_type: /^image\/(jpg|jpeg|pjpeg|png|x-png|gif)$/

  has_attached_file :cover, styles: { thumb: "700x172#", large: "1600x632#"}, convert_options: { thumb: "-quality 30", large: "-quality 30" }
  validates_attachment :cover, size: { in: 0..6.megabytes }
  validates_attachment_content_type :cover, content_type: /^image\/(jpg|jpeg|pjpeg|png|x-png|gif)$/

	# RELATIONS #

	has_many :adoptions, :dependent => :restrict_with_error
	has_many :users, through: :adoptions
	belongs_to :user
  belongs_to :category
	has_many :posts, dependent: :destroy
	has_many :photos, dependent: :destroy
  belongs_to :owner, optional: true, :class_name => 'User'
  belongs_to :editor, :class_name => 'User'

	# METHODS #

	def self.search_owner(pet)
    owner = pet.users.joins(:adoptions).where("adoptions.pet_id = ? AND adoptions.status = ?", pet.id, 'accepted').or(pet.users.joins(:adoptions).where("adoptions.pet_id = ? AND adoptions.status = ? AND adoptions.received = ?", pet.id, 'returned', true)).first
    owner ? owner : owner = pet.user

  end

  def self.owner_admin(pet, current_user)
  	current_user.admin? ? Pet.search_owner(pet) : current_user
  end

  #Verify that current user is equals to pet user
  # Pet Model 
  # Adoption Model 

  def self.equals_current_user?(pet, current_user)
    pet.user_id == current_user.id
  end

  # def self.accepted_owner_equals_current?(pet, current_user)
  #   Adoption.adoption_accepted_user(pet) == current_user.id
  # end

  #Verify the status of the adoptions and allow to edit 
  # Used on 
  # photos/index 
  # posts/index

  def self.owner_editor(pet, user)
    if Adoption.adoption_accepted_received?(user, pet) || Adoption.adoption_received_returned?(user, pet) #if any adoption accepted or returned is received = true
      return true
    elsif Adoption.adoption_received_exists(pet, "accepted") || Adoption.adoption_received_exists(pet, "returned") #if any adoption accepted exists = false
      return false
    elsif Pet.equals_current_user?(pet, user) #if current user equals pet user
      return true
    end
  end


  def self.pet_editor(pet, current_user)
    if current_user && (current_user.id == pet.editor_id || current_user.admin)
      return true
    end
  end

  def self.pet_owner(pet, current_user)
    if pet.owner_id == nil
      current_user && (current_user.id == pet.user_id || current_user.admin)
    elsif current_user && (current_user.id == pet.owner_id || current_user.admin)
      return true
    end
  end

end
