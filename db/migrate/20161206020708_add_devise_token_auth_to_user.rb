class AddDeviseTokenAuthToUser < ActiveRecord::Migration
  def change
    add_column :users, :tokens, :json
    User.reset_column_information
  end
end
