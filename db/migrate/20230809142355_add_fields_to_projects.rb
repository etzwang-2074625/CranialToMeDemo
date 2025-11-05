class AddFieldsToProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :uthealth_primary_grantee, :boolean
    add_column :projects, :project_institution, :string
    add_column :projects, :public_starts_project_number, :string
    add_column :projects, :contact_pi_uthealth_id, :string
    add_column :projects, :contact_pi_era_id, :string
  end
end
