class AddUniqueConstraintToDataRepositoriesName < ActiveRecord::Migration[5.2]
  def up
    add_index :data_repositories, [:user_id, :name], unique: true
  end

  def down
    remove_index :data_repositories, column: [:user_id, :name]
  end
end
