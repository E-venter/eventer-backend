# Controller for sample data
class SampleController < ApplicationController
  def events
    puts "olar: #{params.inspect}"
    # seCorner = params[:cornerSE]
    # nwCorner = params[:cornerNW]
    # current_location = params[:currentLocation]

    events = []
    events.append(latitude: 37.422, longitude: -122.085, name: 't', radius: 2.0)

    render json: { list: events }
  end

  def checkin
    render json: { info: 'not_implemented' }
  end

  def form
  end
end
