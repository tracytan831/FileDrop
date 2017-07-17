class AddUserProfileToDocs < ActiveRecord::Migration[5.0]
  def change
    add_reference :docs, :user_profile, foreign_key: true
  end
end
