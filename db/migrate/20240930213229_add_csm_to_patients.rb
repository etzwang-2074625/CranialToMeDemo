class AddCsmToPatients < ActiveRecord::Migration[5.2]
  def change
    add_column :patients, :awakeCsm, :string
    add_column :patients, :awakeCsm_Tasks, :string
    add_column :patients, :asleepCsm, :string
    add_column :patients, :asleepCsm_Tasks, :string
  end
end
