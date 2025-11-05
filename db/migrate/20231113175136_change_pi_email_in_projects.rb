class ChangePiEmailInProjects < ActiveRecord::Migration[5.2]
  def change
    change_column :projects, :pi_email, :string
  end
end
