class AddQuestionIdToAnswers < ActiveRecord::Migration[6.1]
  def change
    add_belongs_to :answers, :question, index: true
  end
end
