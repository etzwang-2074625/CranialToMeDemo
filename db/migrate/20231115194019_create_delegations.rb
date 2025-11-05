class CreateDelegations < ActiveRecord::Migration[5.2]
  def change
    create_table :delegations do |t|
      t.integer :project_pi_id
      t.integer :pi_delegate_id
      t.string :status

      t.timestamps
    end
  end
end
