class Slider < ApplicationRecord

	validates :título, presence: true
	validates :subtítulo, presence: true

	alias_attribute :título, :title
	alias_attribute :subtítulo, :subtitle
	alias_attribute :botón, :buttontitle

end
