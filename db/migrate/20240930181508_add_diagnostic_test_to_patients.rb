class AddDiagnosticTestToPatients < ActiveRecord::Migration[5.2]
  def change
    add_column :patients, :wada, :string
    add_column :patients, :fmri, :string
    add_column :patients, :csm, :string
  end
end
