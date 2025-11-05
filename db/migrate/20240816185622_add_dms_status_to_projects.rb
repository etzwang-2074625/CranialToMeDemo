class AddDmsStatusToProjects < ActiveRecord::Migration[5.2]
  def up
    add_column :projects, :dms_status, :integer, default: 1
  end

  def down
    remove_column :projects, :dms_status
  end
end
