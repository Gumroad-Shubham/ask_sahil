class CreateQuestion < ActiveRecord::Migration[6.0]
  def change
    create_table :questions do |t|
      t.string :question, limit: 140, null: false
      t.string :strategy, limit: 140, null: false
      t.text :answer, limit: 1000
      t.string :audio_src_url, limit: 255
      t.integer :ask_count, default: 1
      # The timestamps method adds created_at and updated_at columns to the table automatically.
      t.timestamps
    end
  end
end
