class AddNhashIdToProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :nhash_id, :string
  end
end
