class InvitesController < ApplicationController
  include DeviseTokenAuth::Concerns::SetUserByToken

  before_action :generate_token, only: [:create]
  before_action :authenticate_user!, only: [:create]

  def index
  end

  def new
  end

  def create
    event = Event.find_by_id params[:event_id]
    unless event.owner_id == current_user.id
      return render(
          json: {
            success: 'failed',
            errors: ['cant invite to this event']
          },
          status: :forbidden
      )
    end

    @invite = Invite.new invite_params
    @invite.sender_id = current_user.id

    if @invite.save
      if User.find_by_email params[:email]
        EventerMailer.existing_user_invite(@invite)
      else
        EventerMailer.new_user_invite(@invite, user_registration_path(invite_token: @invite.token)).deliver
      end
    else
      render(
          json: {
              success: 'failed',
              error: ['cant create invite']
          },
          status: :forbidden
      )
    end
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def invite_params
    params.permit :email, :event_id, :recipient_id, :token
  end

  def generate_token
    self.token = Digest::SHA1.hexdigest [self.event_id, Time.now, rand].join
  end
end
