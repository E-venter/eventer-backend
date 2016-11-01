class ChangeTypeOfDurationToInteger < ActiveRecord::Migration
  def up
    remove_column :events, :duration
    add_column :events, :duration, :integer
  end

  def down
    remove_column :events, :duration
    add_column :events, :duration, :date
  end
end
