class CreateSubscriptionTable < ActiveRecord::Migration[6.1]
  def change
    create_table :subscription_tables do |t|
      t.belongs_to :user, index: true
      t.belongs_to :question, index: true

      t.timestamps
    end
  end
end
