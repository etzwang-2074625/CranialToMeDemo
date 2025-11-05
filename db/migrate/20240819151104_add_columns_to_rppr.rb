class AddColumnsToRppr < ActiveRecord::Migration[5.2]
  def up
    add_column :rpprs, :data_change, :boolean
    add_column :rpprs, :data_change_description, :text
  end

  def down
    remove_column :rpprs, :data_change
    remove_column :rpprs, :data_change_description
  end
end
