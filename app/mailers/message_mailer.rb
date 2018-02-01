class MessageMailer < ApplicationMailer

	default from: "webcontact@caffora.cafe"

	def pet_creation(pet)
		@pet = pet
		mail(to: pet.user.email, subject: 'Mascota Ingresada a Adopciones')
	end

	def adoption_creation(adoption)
		@adoption = adoption
		mail(to: adoption.user.email, subject: 'Solicitud de Adopción Creada')
	end
end
