class AddPiEmailToProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :pi_email, :integer
  end
end
