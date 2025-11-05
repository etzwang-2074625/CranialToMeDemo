class CreateCcep < ActiveRecord::Migration[5.2]
  def change
    create_table :cceps do |t|
      t.string :master_patient_id, null: false
      t.date :date
      t.string :csm_notes
      t.string :hemisphere
      t.string :seeg_or_sde
      t.string :anode
      t.string :cathode
      t.string :data_available
      t.string :sector_1_file_name
      t.string :time
      t.string :ccep_amplitude
      t.string :notes
      t.string :anode_location
      t.string :cathode_location
      t.string :anode_surf_location
      t.string :cathode_surf_location
      t.boolean :visual_naming
      t.boolean :auditory_repetition
      t.boolean :auditory_naming
    end
  end
end
