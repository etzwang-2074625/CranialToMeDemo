class AddProjectIdToDataRepository < ActiveRecord::Migration[5.2]
  def change
    add_column :data_repositories, :project_id, :integer
  end
end
