class IndexController < ApplicationController
  def home
    @sliders = Slider.all
  end

  def about
  end

  def contact
    @message = Message.new
  end
end
