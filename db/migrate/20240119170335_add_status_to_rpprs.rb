class AddStatusToRpprs < ActiveRecord::Migration[5.2]
  def change
    add_column :rpprs, :status, :integer, default: 1
  end
end
