class CreateLessonCompletions < ActiveRecord::Migration[8.0]
  def change
    create_table :lesson_completions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :lesson, null: false, foreign_key: true
      t.datetime :started_at
      t.datetime :completed_at
      t.boolean :completed, default: false

      t.timestamps
    end
    
    add_index :lesson_completions, [:user_id, :lesson_id], unique: true
  end
end
