# Controller for sample data
class SampleController < ApplicationController
  include DeviseTokenAuth::Concerns::SetUserByToken

  before_action :authenticate_user!
  def events
    puts "olar: #{params.inspect}"
    puts "image: #{params[:binary_file].inspect}"
    puts "methods:\n#{params[:binary_file].methods}\n---"
    puts "class:\n#{params[:binary_file].class}\n---"
    # seCorner = params[:cornerSE]
    # nwCorner = params[:cornerNW]
    # current_location = params[:currentLocation]

    events = []
    events.append(latitude: 37.422, longitude: -122.085, name: 't', radius: 2.0)

    render json: { list: events }
  end

  def checkin
    puts "olar: #{params.inspect}"
    puts "image: #{params[:binary_file].inspect}"
    puts "methods:\n#{params[:binary_file].methods}\n---"
    puts "class:\n#{params[:binary_file].class}\n---"
    puts '--------------------------------'
    puts "got image #{params[:binary_file].inspect}"
    puts "got tempfile #{params[:binary_file].tempfile.inspect}"
    filename = "/home/roberto/file_#{current_user.name}_photo.jpg"
    puts "saving image as: #{filename}"
    FileManager.save_file(params[:binary_file].tempfile, filename)
    render json: { info: 'not_implemented' }
  end

  def form
  end
end
