class AddSurgeryDetailsToPatients < ActiveRecord::Migration[5.2]
  def change
    add_column :patients, :surgHemi, :string
    add_column :patients, :surgType, :string
    add_column :patients, :surgDescription, :string
    add_column :patients, :surgDate, :date
  end
end
