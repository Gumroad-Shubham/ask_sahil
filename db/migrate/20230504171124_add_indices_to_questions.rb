class AddIndicesToQuestions < ActiveRecord::Migration[6.0]
  def change
    add_index :questions, :question
    add_index :questions, :strategy
  end
end
