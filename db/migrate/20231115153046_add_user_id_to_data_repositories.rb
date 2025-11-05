class AddUserIdToDataRepositories < ActiveRecord::Migration[5.2]
  def change
    add_column :data_repositories, :user_id, :integer
  end
end
