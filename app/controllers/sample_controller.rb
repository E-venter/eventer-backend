class SampleController < ApplicationController
  def events
    puts "olar: #{params.inspect}"
    #return render text: 'potato123'
    seCorner = params[:cornerSE]
    nwCorner = params[:cornerNW]
    current_location = params[:currentLocation]

    events = []
    events.append({ latitude: 37.422, longitude: -122.085, name: 'jesus te ama', radius: 2.0 })

    render json: { list: events }.to_json
  end
  def form
  end
end
