class ContactMailer < ApplicationMailer

	default from: "Your Mailer <webcontact@caffora.cafe>"
  default to: "Your Name <info@caffora.cafe>"

  def new_message(message)
    @message = message
    
    mail subject: "Message from #{message.name}"
  end

end
