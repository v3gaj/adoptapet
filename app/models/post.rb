class Post < ApplicationRecord

	attr_accessor :image

	# CONSTANTS #

	POSTSPERREFRESH = 5


	# RELATIONS #

	has_one :photo
	belongs_to :pet

	# VALIDATIONS #

	validates :comment, presence: true



	def self.posts_less_or_equals_five(pet, count)
    pet.posts.count == count ? true : false
  end

end
