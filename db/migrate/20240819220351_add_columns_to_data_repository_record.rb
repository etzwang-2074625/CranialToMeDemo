class AddColumnsToDataRepositoryRecord < ActiveRecord::Migration[5.2]
  def up
    add_column :data_repository_records, :doi, :text
  end

  def down
    remove_column :data_repository_records, :doi
  end
end
