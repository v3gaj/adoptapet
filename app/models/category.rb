class Category < ApplicationRecord

	# RELATIONS #

	has_many :pets, :dependent => :restrict_with_error

	# VALIDATIONS #

  	validates :title, presence: true 

end
