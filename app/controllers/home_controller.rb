class HomeController < ApplicationController
  before_action :set_schedule_data

  def index
    @event = Event.new
    @events = current_user ? current_user.events.order(:start_time) : Event.none
    @start_date = params[:start_date] ? Date.parse(params[:start_date]) : Date.today.beginning_of_month
    @unread_count = current_user ? current_user.unread_bookings.count : 0
  end
end
