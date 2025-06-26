class HomeController < ApplicationController
  before_action :set_schedule_data

  def index
    @event = Event.new
    @events = current_user ? current_user.events.order(:start_time) : Event.none
  end
end
