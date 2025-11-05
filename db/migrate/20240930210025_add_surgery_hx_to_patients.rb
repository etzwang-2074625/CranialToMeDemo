class AddSurgeryHxToPatients < ActiveRecord::Migration[5.2]
  def change
    add_column :patients, :surgHx, :string
    add_column :patients, :surgHxHemi, :string
    add_column :patients, :surgHxType, :string
    add_column :patients, :surgHxDate, :date
  end
end
