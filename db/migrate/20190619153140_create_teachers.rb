class CreateTeachers < ActiveRecord::Migration[5.2]
  def change
    create_table :teachers do |t|
      t.string :teacher_id
      t.string :name
      t.references :college, foreign_key: true

      t.timestamps
    end
  end
end
