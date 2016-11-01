class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.string :owner_id
      t.string :address
      t.float :latitude
      t.float :longitude
      t.text :description
      t.datetime :start_time
      t.time :duration
      t.string :private

      t.timestamps null: false
    end
  end
end
