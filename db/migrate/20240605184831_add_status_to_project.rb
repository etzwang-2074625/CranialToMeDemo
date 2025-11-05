class AddStatusToProject < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :status, :string, default: 'active'
  end
end
