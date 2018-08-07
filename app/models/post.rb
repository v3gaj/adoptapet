class Post < ApplicationRecord

	# CONSTANTS #

	POSTSPERREFRESH = 5


	# RELATIONS #

	belongs_to :pet


	# VALIDATIONS #

	validates :comment, presence: true

	has_attached_file :image, styles: { medium: "600X"}, convert_options: { medium: '-quality 30' }
	validates_attachment :image, size: { in: 0..6.megabytes }
	validates_attachment_content_type :image, content_type: /^image\/(jpg|jpeg|pjpeg|png|x-png|gif)$/

	def self.posts_less_or_equals_five(pet, count)
    	pet.posts.count == count ? true : false
  	end

end
