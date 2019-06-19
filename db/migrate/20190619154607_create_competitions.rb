class CreateCompetitions < ActiveRecord::Migration[5.2]
  def change
    create_table :competitions do |t|
      t.string :name
      t.integer :version
      t.date :deadline
      t.date :endtime

      t.timestamps
    end
  end
end
