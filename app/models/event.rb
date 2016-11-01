# Event model class
class Event < ActiveRecord::Base
  acts_as_mappable  default_units: :kms,
                    lat_column_name: :latitude,
                    lng_column_name: :longitude
end
