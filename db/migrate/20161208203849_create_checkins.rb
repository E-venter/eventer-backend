class CreateCheckins < ActiveRecord::Migration
  def change
    create_table :checkins do |t|
      t.integer :event
      t.integer :user

      t.timestamps null: false
    end
  end
end
