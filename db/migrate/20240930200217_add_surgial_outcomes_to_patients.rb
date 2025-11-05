class AddSurgialOutcomesToPatients < ActiveRecord::Migration[5.2]
  def change
    add_column :patients, :ilae, :integer
    add_column :patients, :engel, :string
    add_column :patients, :etiology, :string
    add_column :patients, :mri, :string
  end
end
