class CreatePatientTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :patient_tasks do |t|
      t.string :master_patient_id, null: false
      t.string :task_name, null: false
      t.integer :task_count, default: 0

      t.timestamps
    end

    add_index :patient_tasks, :master_patient_id
    add_index :patient_tasks, :task_name
  end
end
