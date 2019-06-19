class CreateStudents < ActiveRecord::Migration[5.2]
  def change
    create_table :students do |t|
      t.string :student_id
      t.string :name
      t.string :email
      t.string :password_digest
      t.references :college, foreign_key: true

      t.timestamps
    end
  end
end
