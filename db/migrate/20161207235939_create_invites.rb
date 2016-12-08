class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.integer :event
      t.integer :invited

      t.timestamps null: false
    end
  end
end
