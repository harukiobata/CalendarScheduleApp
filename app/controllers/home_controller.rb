class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    @events = current_user ? current_user.events.order(:start_time) : Event.none
  end
end
