# Event model class
class Event < ActiveRecord::Base
  acts_as_mappable  default_units: :kms,
                    lat_column_name: :latitude,
                    lng_column_name: :longitude

  validates_presence_of(
    :name, :latitude, :longitude,
    :owner_id, :address, :description, :start_time,
    :private, :duration, :radius
  )

  def public
    !private
  end
end
