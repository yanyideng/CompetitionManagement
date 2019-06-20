class CreateAchievements < ActiveRecord::Migration[5.2]
  def change
    create_table :achievements do |t|
      t.references :group, foreign_key: true
      t.string :prize

      t.timestamps
    end
  end
end
