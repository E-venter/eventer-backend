# Controller to handle Event operations
class EventController < ApplicationController
  include DeviseTokenAuth::Concerns::SetUserByToken

  before_filter :checkin_params, only: [:checkin]
  before_action :authenticate_user!
  skip_before_filter :verify_authenticity_token

  def create
    unless current_user
      return render json: { success: false, errors: ['failed to authenticate'] }
    end
    info = params[:info]
    info[:owner_id] = current_user.id
    info[:start_time] = Time.at(info[:start_time].to_i)
    info[:end_time] = Time.at(info[:end_time].to_i)
    info[:duration] = info[:end_time] - info[:start_time]
    info[:radius] = 5
    # event_attrs(info, :owner_id, :start_time, :end_time, :duration, :radius)

    event = Event.create!(info)
    render json: {
      success: true,
      event: event.inspect,
      user: current_user.inspect
    }
  end

  def my_events
    unless current_user
      return render json: { success: false, errors: ['failed to authenticate'] }
    end

    events = []
    Event.find_by_owner_id(current_user.id).each do |e|
      events.append visible_attr(e, current_user)
    end

    render json: {
        success: 'success',
        errors: [],
        status: :ok,
        events: events
    }

  end

  def visible_events
    unless current_user
      return render json: { success: false, errors: ['failed to authenticate'] }
    end
    info = JSON.load(params[:info])
    puts "info is:\n#{info.inspect}\n--#{info.class}--"
    sw_corner = info['corner_sw']
    puts "SW: #{sw_corner}"
    ne_corner = info['corner_ne']
    puts "NE: #{ne_corner}"

    events = []
    Event.visible(
        sw_corner: sw_corner,
        ne_corner: ne_corner
    # ).where("event_type <> 'private' AND end_time > ?", Time.now).each do |e|
    ).where(event_type: 'public').each do |e|
      u = User.find_by_id e.owner_id.to_i
      events.append visible_attr(e, u)
    end
    puts "responding with:\n #{events}\nended ------"
    render json: { list: events }
  end

  private

  def event_attrs(hash, *keys)
    hash.select do |k, _v|
      keys.include? k
    end
  end

  def visible_attr(event, u)
    ret = event.serializable_hash
    ret['start_time'] = event['start_time'].to_datetime.strftime('%Q').to_i
    ret['end_time'] = event['end_time'].to_datetime.strftime('%Q').to_i
    checkin = Checkin.find_by_event_and_user(event['id'], u.id)
    ret['checked_in'] = ! checkin.any?
    ret
      .except('created_at', 'updated_at', 'owner_id', 'duration')
      .merge('owner_name' => u.name, 'owner_email' => u.email)
  end
end