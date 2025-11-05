class AddDrTypeToDataRepositories < ActiveRecord::Migration[5.2]
  def change
    add_column :data_repositories, :dr_type, :string
  end
end
