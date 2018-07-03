class ContactMailer < ApplicationMailer

	default from: "Your Mailer <webcontact@adoptmypet.org>"
  default to: "Your Name <info@adoptmypet.org>"

  def new_message(message)
    @message = message
    
    mail subject: "Message from #{message.name}"
  end

end
