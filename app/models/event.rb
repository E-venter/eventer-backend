# Event model class
class Event < ActiveRecord::Base
  acts_as_mappable  default_units: :kms,
                    lat_column_name: :latitude,
                    lng_column_name: :longitude

  validates_presence_of(
    :name, :latitude, :longitude,
    :owner_id, :address, :description, :start_time,
    :event_type, :duration, :radius
  )

  has_many :invites

  def self.visible(options = {})
    sw = options[:sw_corner]
    ne = options[:ne_corner]
    Event.in_bounds(
        [
            [sw['latitude'].to_f, sw['longitude'].to_f],
            [ne['latitude'].to_f, ne['longitude'].to_f]
        ]
    )
  end
end
