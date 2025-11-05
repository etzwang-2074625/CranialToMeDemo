class AddNeurostimulationToPatients < ActiveRecord::Migration[5.2]
  def change
    add_column :patients, :vns, :string
    add_column :patients, :prime, :string
    add_column :patients, :thalamusStim, :string
    add_column :patients, :meg, :string
  end
end
