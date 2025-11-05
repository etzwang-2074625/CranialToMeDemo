class AddDataRepositoryNaToRpprs < ActiveRecord::Migration[5.2]
  def change
    add_column :rpprs, :data_repository_na, :boolean, default: false
  end
end
