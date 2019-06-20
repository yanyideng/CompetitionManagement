class AddIndexToTeachersTeacherId < ActiveRecord::Migration[5.2]
  def change
    add_index :teachers, :teacher_id
  end
end
