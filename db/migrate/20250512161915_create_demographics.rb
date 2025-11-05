class CreateDemographics < ActiveRecord::Migration[5.2]
  def change
    create_table :demographics do |t|
      t.string :master_patient_id, null: false
      t.string :otherIds
      t.integer :mrn
      t.string :firstName
      t.string :lastName
      t.date :dob
      t.integer :age
      t.string :sex
      t.integer :aoo
      t.string :ehi
      t.string :ld
      t.string :wada
      t.string :fmriSide
      t.string :csm
      t.string :surgHemi
      t.string :surgType
      t.string :surgDesc
      t.date :dos
      t.integer :ilae
      t.integer :engle
      t.string :etiology
      t.string :mri
      t.string :surgHx
      t.string :surgHxHemi
      t.string :surgHxType
      t.date :surgHxDate
      t.date :preNpDoe
      t.date :postNpDoe
      t.integer :fsiq
      t.string :english
      t.string :vns
      t.string :ecogHemi
      t.string :ecog
      t.date :implantDate
      t.date :explantDate
      t.integer :common
      t.integer :commonRgb
      t.integer :auditory
      t.integer :audscramble
      t.integer :rsvpCueNaming
      t.integer :action
      t.integer :perData3
      t.integer :perData5
      t.integer :perData7
      t.integer :matchingAuditory
      t.integer :matchingOrthographic
      t.integer :matchingVisual
      t.string :awakeCsm
      t.string :awakeCsmTask
      t.string :asleepCsm
      t.string :asleepCsmTask
      t.string :cceps
      t.string :prime
      t.string :thalamusStim
      t.string :meg
      t.string :rearranged
      t.string :reimplant
      t.string :reop
      t.string :postOpMri
      t.string :meg
      t.string :fmri
      t.string :rns
      t.string :dbs
      t.date :dbsPhase2
      t.string :dbsPostTest
      t.string :combo
      t.string :alice
      t.string :notes

      t.timestamps
    end

    add_index :demographics, :master_patient_id, unique: true
  end
end
