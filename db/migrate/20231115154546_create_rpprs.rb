class CreateRpprs < ActiveRecord::Migration[5.2]
  def change
    create_table :rpprs do |t|
      t.integer :project_id
      t.integer :year_start
      t.integer :year_end
      t.text :abstract
      t.integer :data_repository_id
      t.string :supplemental_info

      t.timestamps
    end
  end
end
