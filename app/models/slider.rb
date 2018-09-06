class Slider < ApplicationRecord

	validates :título, presence: true
	validates :subtítulo, presence: true

	alias_attribute :título, :title
	alias_attribute :subtítulo, :subtitle
	alias_attribute :botón, :buttontitle

	has_attached_file :image, styles: { original: '2250x1500#' }, convert_options: { original: '-quality 30' }
	validates_attachment_size :image, in: 0..3.megabytes
	validates_attachment_content_type :image, content_type: /^image\/(jpg|jpeg|pjpeg|png|x-png|gif)$/

end
