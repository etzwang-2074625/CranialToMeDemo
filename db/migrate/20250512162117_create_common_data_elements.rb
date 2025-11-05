class CreateCommonDataElements < ActiveRecord::Migration[5.2]
  def change
    create_table :common_data_elements do |t|
      t.string :element_name, null: false
      t.string :local_variable_name
      t.text :description
      t.string :data_type
      t.string :source_url

      t.timestamps
    end

    add_index :common_data_elements, :element_name
    add_index :common_data_elements, :local_variable_name
  end
end
