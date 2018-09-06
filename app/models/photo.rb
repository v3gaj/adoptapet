class Photo < ApplicationRecord

	# RELATIONS #

	belongs_to :pet
	belongs_to :post, optional: true


	# VALIDATIONS #

	has_attached_file :photo, styles: { original: '1680X', medium: "600X"}, convert_options: { original: '-quality 30', medium: '-quality 30' }
	validates_attachment :photo, presence: true, size: { in: 0..6.megabytes }
	validates_attachment_content_type :photo, content_type: /^image\/(jpg|jpeg|pjpeg|png|x-png|gif)$/

end
