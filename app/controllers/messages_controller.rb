class MessagesController < ApplicationController

  def new
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)
    respond_to do |format|
      if @message.valid?
        ContactMailer.new_message(@message).deliver
        format.js   { render :layout => false }
      else
        format.js   { render :layout => false }
      end
    end
  end

private

  def message_params
    params.require(:message).permit(:name, :email, :content)
  end

end
