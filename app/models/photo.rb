class Photo < ApplicationRecord

	# RELATIONS #

	belongs_to :pet


	# VALIDATIONS #

	has_attached_file :photo, styles: { normal: '1680x1120#' }, convert_options: { normal: '-quality 30' }
	validates_attachment :photo, presence: true, size: { in: 0..6.megabytes }
	validates_attachment_content_type :photo, content_type: /^image\/(jpg|jpeg|pjpeg|png|x-png|gif)$/

end
