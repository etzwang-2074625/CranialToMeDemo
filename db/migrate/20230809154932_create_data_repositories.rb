class CreateDataRepositories < ActiveRecord::Migration[5.2]
  def change
    create_table :data_repositories do |t|
      t.string :name
      t.string :repository_url
      t.string :description

      t.timestamps
    end
  end
end
