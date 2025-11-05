class CreatePatients < ActiveRecord::Migration[5.2]
  def change
    create_table :patients do |t|
      t.string :subject
      t.string :otherIDs
      t.integer :age
      t.string :sex
      t.integer :onsetAge
      t.string :handedness
      t.string :domHemi

      t.timestamps
    end
  end
end
