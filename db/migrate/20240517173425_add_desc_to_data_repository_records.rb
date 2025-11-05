class AddDescToDataRepositoryRecords < ActiveRecord::Migration[5.2]
  def change
    add_column :data_repository_records, :desc, :text
  end
end
