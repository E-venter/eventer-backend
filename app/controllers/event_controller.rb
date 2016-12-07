# Controller to handle Event operations
class EventController < ApplicationController
  include DeviseTokenAuth::Concerns::SetUserByToken

  before_action :authenticate_user!
  skip_before_filter :verify_authenticity_token

  def create
    unless current_user
      return render json: { success: false, errors: ['failed to authenticate'] }
    end
    info = params[:info]
    dur = info[:duration].to_i

    event = Event.new(
      name: info[:name], owner_id: current_user.id, address: info[:address],
      latitude: info[:latitude], longitude: info[:longitude],
      description: info[:description],
      start_time: Time.at(info[:startTime].to_i),
      private: (info[:private] == '1'), duration: dur, radius: 5
    )
    event.save!
    render json: {
      success: true,
      event: event.inspect,
      user: current_user.inspect
    }
  end

  def visible_events
    unless current_user
      return render json: { success: false, errors: ['failed to authenticate'] }
    end
    se_corner = params[:cornerSE].to_f
    nw_corner = params[:cornerNW].to_f

    events = Event.in_bounds(
      [
        [se_corner[:latitude], nw_corner[:longitude]],
        [nw_corner[:latitude], se_corner[:longitude]]
      ]
    ).where(private: false)
    render json: { events: events }
  end
end
