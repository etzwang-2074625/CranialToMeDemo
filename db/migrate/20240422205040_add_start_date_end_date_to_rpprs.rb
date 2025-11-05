class AddStartDateEndDateToRpprs < ActiveRecord::Migration[5.2]
  def change
    add_column :rpprs, :start_date, :datetime
    add_column :rpprs, :end_date, :datetime
  end
end
