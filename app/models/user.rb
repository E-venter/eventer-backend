# Facebook OAuth user
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  validates_uniqueness_of :email, :uid

  devise :database_authenticatable, :registerable,
         :recoverable, :trackable, :validatable

  has_many :invitations, :class_name => 'Invite', :foreign_key => 'recipient_id'
  has_many :sent_invites, :class_name => 'Invite', :foreign_key => 'sender_id'

  include DeviseTokenAuth::Concerns::User
end
