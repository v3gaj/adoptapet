class MessagesController < ApplicationController

  def new
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)
    
    if @message.valid?
      ContactMailer.new_message(@message).deliver
      redirect_to contact_path, notice: "El mensaje ha sido enviado."
    else
      flash[:alert] = "Ha ocurrido un error al enviar el mensaje."
      redirect_to contact_path
    end
  end

private

  def message_params
    params.require(:message).permit(:name, :email, :content)
  end

end
