class ChangePrivateToTypeEvent < ActiveRecord::Migration
  def change
    remove_column :events, :private
    add_column :events, :type, :string
    add_column :events, :end_time, :datetime
  end
end
