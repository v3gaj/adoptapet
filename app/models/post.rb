class Post < ApplicationRecord

	# RELATIONS #

	belongs_to :pet


	# VALIDATIONS #

	validates :comment, presence: true

	has_attached_file :image, styles: { medium: "600X"}
	validates_attachment :image, 
												size: { in: 0..3.megabytes }

	validates_attachment_content_type :image, content_type: /^image\/(jpg|jpeg|pjpeg|png|x-png|gif)$/

end
