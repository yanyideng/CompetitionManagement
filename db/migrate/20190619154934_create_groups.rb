class CreateGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :groups do |t|
      t.string :name
      t.string :mema
      t.string :memb
      t.string :memc
      t.string :memd
      t.integer :isteam
      t.references :student, foreign_key: true
      t.references :competition, foreign_key: true

      t.timestamps
    end
  end
end
