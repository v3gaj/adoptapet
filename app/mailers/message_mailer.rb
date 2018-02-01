class MessageMailer < ApplicationMailer

	default from: "webcontact@caffora.cafe"

	def pet_created(pet)
		@pet = pet
		mail(to: pet.user.email, subject: 'Mascota Ingresada a Adopciones')
	end

	def pet_deleted(pet)
		@pet = pet
		mail(to: pet.user.email, subject: 'Perfil de la Mascota Eliminado')
	end

	def adoption_created(adoption, pet)
		@adoption = adoption
		mail(to: adoption.user.email, subject: 'Solicitud de Adopción Creada')
	end

	def adoption_created_owner(adoption, pet)
		owner = Pet.search_owner(pet)
		@adoption = adoption
		mail(to: owner.email, subject: 'Solicitud de Adopción Creada')
	end
end
