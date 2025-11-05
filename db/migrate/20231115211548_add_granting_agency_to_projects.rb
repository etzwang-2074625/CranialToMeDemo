class AddGrantingAgencyToProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :granting_agency, :string
  end
end
