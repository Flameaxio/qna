class AddQuestionIdToAttachment < ActiveRecord::Migration[6.1]
  def change
    add_column :attachments, :attachable_id, :integer
    add_column :attachments, :attachable_type, :string
    add_index :attachments, %i[attachable_id attachable_type]
  end
end
