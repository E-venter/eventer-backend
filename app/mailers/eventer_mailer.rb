class EventerMailer < ApplicationMailer
  def new_user_invite(invite, registration_link)
    @invite = invite
    @link = registration_link
    mail(to: @invite.email, subject: 'Event Invite')
  end

  def existing_user_invite(invite)
    # code here
  end
end
