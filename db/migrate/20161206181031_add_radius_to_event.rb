class AddRadiusToEvent < ActiveRecord::Migration
  def change
    add_column :events, :radius, :float
  end
end
