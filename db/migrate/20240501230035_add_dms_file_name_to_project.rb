class AddDmsFileNameToProject < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :dms_plan_file_name, :string
    add_column :projects, :dms_plan_file, :string
    add_column :rpprs, :due_date, :datetime
  end
end
