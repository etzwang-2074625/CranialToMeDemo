class AddImplantationToPatients < ActiveRecord::Migration[5.2]
  def change
    add_column :patients, :ecog_hemi, :string
    add_column :patients, :ecog, :string
    add_column :patients, :implantDate, :date
    add_column :patients, :explantDate, :date
  end
end
