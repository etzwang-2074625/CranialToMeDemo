class AddCognitiveEvaluationsToPatients < ActiveRecord::Migration[5.2]
  def change
    add_column :patients, :preNP_DOE, :date
    add_column :patients, :postNP_DOE, :date
    add_column :patients, :fsiq, :integer
    add_column :patients, :english, :string
  end
end
