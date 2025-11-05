class CreateDataRepositoryRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :data_repository_records do |t|
      t.integer :data_repository_id
      t.integer :rppr_id
      t.string :screenshot_evidence

      t.timestamps
    end
  end
end
