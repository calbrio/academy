class AddLessonContentToLessons < ActiveRecord::Migration[7.0]
  def change
    add_column :lessons, :lesson_content, :text
  end
end
