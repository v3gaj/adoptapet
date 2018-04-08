class User < ApplicationRecord


  # FRIENDLY ID #

	extend FriendlyId
	friendly_id :user_name, use: :slugged

	def user_name
   [
    [:name, :lastName, :sequence],
   ]
  end

  def sequence
    slug = normalize_friendly_id(name+"-"+lastName)
    sequence = User.where("slug LIKE :prefix", prefix: "#{slug}%").count
    sequence > 0 ? "-#{sequence}" : nil
  end

  # VALIDATIONS #

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  has_attached_file :photo, styles: { thumb: "100x100#", large: "300x300#"}, convert_options: { thumb: "-quality 50", large: "-quality 50" }
	validates_attachment :photo, size: { in: 0..3.megabytes }
	validates_attachment_content_type :photo, content_type: /^image\/(jpg|jpeg|pjpeg|png|x-png|gif)$/


  validates :name, presence: true
  validates :lastName, presence: true


  # RELATIONS #

  has_many :pets, :dependent => :restrict_with_error
  has_many :adoptions, :dependent => :restrict_with_error
  has_many :animals, through: :adoptions, :dependent => :restrict_with_error
  has_many :owned_pets, :class_name => 'Pet', :foreign_key => 'owner_id'
  has_many :edited_pets, :class_name => 'Pet', :foreign_key => 'editor_id'

  # METHODS #

  def full_name
    return "#{name.split.map(&:capitalize).join(' ')} #{lastName.split.map(&:capitalize).join(' ')}"
    "Anonymous"
  end

  
  
end
