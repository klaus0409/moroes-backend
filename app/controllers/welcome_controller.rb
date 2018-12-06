class WelcomeController < ApplicationController
  def index
    if current_user.museum.present?
      redirect_to museum_url(current_user.museum)
    else
      redirect_to museums_url
    end
  end
end
