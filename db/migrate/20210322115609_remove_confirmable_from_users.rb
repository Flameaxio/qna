class RemoveConfirmableFromUsers < ActiveRecord::Migration[6.1]
  def change
    remove_index :users, :confirmation_token
    remove_columns :users, :confirmation_token, :confirmed_at, :confirmation_sent_at
  end
end
