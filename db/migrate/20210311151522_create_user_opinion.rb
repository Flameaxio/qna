class CreateUserOpinion < ActiveRecord::Migration[6.1]
  def change
    create_table :user_opinions do |t|
      t.belongs_to :user, index: true
      t.belongs_to :answer, index: true
      t.integer :opinion, default: 0
      t.timestamps
    end
  end
end
