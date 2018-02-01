class MessageMailer < ApplicationMailer

	default from: "webcontact@caffora.cafe"

	def pet_creation(pet)
		@pet = pet
		mail(to: pet.user.email, subject: 'Mascota Ingresada a Adopciones')
	end
end
