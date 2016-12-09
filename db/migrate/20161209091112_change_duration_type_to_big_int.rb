class ChangeDurationTypeToBigInt < ActiveRecord::Migration
  def change
    change_column :events, :duration, :decimal, limit: 15
  end
end
