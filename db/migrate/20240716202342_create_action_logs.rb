class CreateActionLogs < ActiveRecord::Migration[5.2]
  def up
    create_table :action_logs do |t|
      t.integer :user_id
      t.integer :subject_id
      t.string :subject_type
      t.text :data

      t.timestamps
    end
  end

  def down
    drop_table :action_logs
  end
end
