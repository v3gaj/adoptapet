class MessageMailer < ApplicationMailer
	include Rails.application.routes.url_helpers

	default from: "info@adoptmypet.org"

	def pet_created(pet)
		@pet = pet
		mail(to: pet.user.email, subject: 'Mascota Ingresada a Adopciones')
	end

	def pet_deleted(pet)
		@pet = pet
		mail(to: pet.user.email, subject: 'Perfil de la Mascota Eliminado')
	end

	def adoption_created(adoption)
		@adoption = adoption
		mail(to: adoption.user.email, subject: 'Solicitud de Adopción Creada')
	end

	def adoption_created_owner(adoption, pet)
		owner = Pet.search_owner(pet)
		@adoption = adoption
		mail(to: owner.email, subject: 'Solicitud de Adopción Creada')
	end

	def adoption_accepted(adoption, owner)
		@owner = owner
		@adoption = adoption
		mail(to: adoption.user.email, subject: 'Solicitud de Adopción Aceptada')
	end

	def adoption_accepted_owner(adoption, owner)
		@owner = owner
		@adoption = adoption
		mail(to: owner.email, subject: 'Solicitud de Adopción Aceptada')
	end

	def adoption_rejected(adoption)
		@adoption = adoption
		mail(to: adoption.user.email, subject: 'Solicitud de Adopción Incompleta')
	end

	def adoption_deleted(adoption)
		@adoption = adoption
		mail(to: adoption.user.email, subject: 'Solicitud de Adopción Eliminada')
	end

	def adoption_deleted_owner(adoption, pet)
		owner = Pet.search_owner(pet)
		@adoption = adoption
		mail(to: owner.email, subject: 'Solicitud de Adopción Eliminada')
	end

	def adoption_returned(adoption)
		@adoption = adoption
		mail(to: adoption.user.email, subject: 'Mascota Retornada al Proceso de Adopción')
	end

	def adoption_returned_owner(adoption, owner)
		@adoption = adoption
		mail(to: owner.email, subject: 'Mascota Retornada al Proceso de Adopción')
	end

	def adoption_reactivated(adoption)
		@adoption = adoption
		mail(to: adoption.user.email, subject: 'Solicitud de Adopción Reactivada')
	end

	def adoption_received(adoption)
		@adoption = adoption
		mail(to: adoption.user.email, subject: 'Solicitud de Adopción Recibida')
	end

	def adoption_keep(adoption)
		@adoption = adoption
		mail(to: adoption.user.email, subject: 'Conservar Mascota')
	end
end
