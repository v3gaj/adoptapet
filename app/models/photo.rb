class Photo < ApplicationRecord

	# RELATIONS #

	belongs_to :pet


	# VALIDATIONS #

	has_attached_file :photo
	validates_attachment :photo,
												presence: true, 
												size: { in: 0..3.megabytes }

	validates_attachment_content_type :photo, content_type: /^image\/(jpg|jpeg|pjpeg|png|x-png|gif)$/

end
