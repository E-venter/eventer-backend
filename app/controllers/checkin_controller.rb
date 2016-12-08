class CheckinController < ApplicationController
  include DeviseTokenAuth::Concerns::SetUserByToken

  before_filter :checkin_params, only: [:create]
  before_action :authenticate_user!
  skip_before_filter :verify_authenticity_token

  def create
    image = params[:binary_file]
    event_id = params[:event_id].to_i
    unless Checkin.find_by_event_and_user event_id, current_user.id
      return render(
          json: { success: 'failed', errors: ['already checked in'] },
          status: :forbidden
      )
    end
    unless image
      return render(
          json: { success: 'failed', errors: ['image not found'] },
          status: :bad_request
      )
    end
    resp = FACE.detection.detect img: image.tempfile.path
    puts "done with FACE++\n#{resp}\n----"
    if resp['face'].empty? || resp['face'].count > 1
      puts 'no face'
      return render(
          json: { success: 'failed', errors: ['face not found or too many faces'] },
          status: :not_acceptable
      )
    end
    face_id2 = resp['face'].first['face_id']
    face_id = current_user.picture
    resp = FACE.recognition.compare face_id1: face_id, face_id2: face_id2
    puts "got face comparision #{resp.inspect}"
    correct = resp['similarity'] >= FacePlusPlus::SIMILARITY_THRESHOLD
    unless correct
      return render(
          json: { success: 'failed', errors: ['face does not match last']},
          status: :precondition_failed
      )
    end

    c = Checkin.create(event: event_id, user: current_user.id)
    render(
        json: { success: 'success', event_id: event_id },
        status: :ok
    )
  end

  private

  def checkin_params
    params.permit(:current_position, :event_id, :binary_file)
  end
end
