# Controller to handle Event operations
class EventController < ApplicationController
  include DeviseTokenAuth::Concerns::SetUserByToken
  include Geokit::Geocoders

  before_action :authenticate_user!
  skip_before_filter :verify_authenticity_token

  def create
    unless current_user
      return render json: { success: false, errors: ['failed to authenticate'] }
    end
    params[:owner_id] = current_user.id
    params[:start_time] = Time.at(params[:start_time].to_i)
    params[:end_time] = Time.at(params[:end_time].to_i)
    # params[:duration] = params[:end_time] - params[:start_time]
    params[:duration] = params[:end_time] - params[:start_time]
    if params[:address].nil? || params[:address] == ''
      params[:address] = (MultiGeocoder.reverse_geocode [params[:latitude].to_f, params[:longitude].to_f]).full_address
    end
    puts "addr: #{params[:address]}"
    # event_attrs(info, :owner_id, :start_time, :end_time, :duration, :radius)

    event = Event.create!(params.permit(:name, :radius, :event_type, :address, :latitude, :longitude, :description, :start_time, :end_time, :duration, :owner_id))
    render(
        json: {
            success: 'success',
            event: visible_attr(event, current_user)
        },
        status: :ok
    )
  end

  def my_events
    unless current_user
      return render(
          json: { success: false, errors: ['failed to authenticate'] },
          status: :unauthorized
      )
    end

    events = []
    Event.find_by_owner_id(current_user.id).each do |e|
      events.append visible_attr(e, current_user)
    end

    render(
        json: { success: 'success', errors: [], events: events },
        status: :ok
    )

  end

  def visible_events
    unless current_user
      return render json: { success: false, errors: ['failed to authenticate'] }
    end
    # info = JSON.load(params[:info])
    # puts "info is:\n#{info.inspect}\n--#{info.class}--"
    sw_corner = params['corner_sw']
    if sw_corner.is_a? String
      sw_corner = JSON.parse(sw_corner)
    end
    puts "SW: #{sw_corner.class}"
    ne_corner = params['corner_ne']
    if ne_corner.is_a? String
      ne_corner = JSON.parse(ne_corner)
    end
    puts "NE: #{ne_corner.class}"

    events = []
    ev = Event.visible(
        sw_corner: sw_corner,
        ne_corner: ne_corner
    )
    # ).where("event_type <> 'private' AND end_time > ?", Time.now).each do |e|
    # e.where(event_type: 'public').where('end_time >= :now', Time.current).limit(100).each do |e|
    ev = ev
        .where('event_type = \'public\' OR owner_id = \'?\'', current_user.id)
        .where('end_time >= :now', now: Time.current)
        .limit(100)
    ev.each do |e|
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
    ret['checked_in'] = ! checkin.nil?
    ret
      .except('created_at', 'updated_at', 'owner_id', 'duration')
      .merge('owner_name' => u.name, 'owner_email' => u.email)
  end
end