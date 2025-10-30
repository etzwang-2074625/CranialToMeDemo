# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2025_10_13_171819) do

  create_table "cceps", force: :cascade do |t|
    t.string "master_patient_id", null: false
    t.date "date"
    t.string "csm_notes"
    t.string "hemisphere"
    t.string "seeg_or_sde"
    t.string "anode"
    t.string "cathode"
    t.string "data_available"
    t.string "sector_1_file_name"
    t.string "time"
    t.string "ccep_amplitude"
    t.string "notes"
    t.string "anode_location"
    t.string "cathode_location"
    t.string "anode_surf_location"
    t.string "cathode_surf_location"
    t.boolean "visual_naming"
    t.boolean "auditory_repetition"
    t.boolean "auditory_naming"
  end

  create_table "common_data_elements", force: :cascade do |t|
    t.string "element_name", null: false
    t.string "local_variable_name"
    t.text "description"
    t.string "data_type"
    t.string "source_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["element_name"], name: "index_common_data_elements_on_element_name"
    t.index ["local_variable_name"], name: "index_common_data_elements_on_local_variable_name"
  end

  create_table "demographics", force: :cascade do |t|
    t.string "master_patient_id", null: false
    t.string "otherIds"
    t.integer "mrn"
    t.string "firstName"
    t.string "lastName"
    t.date "dob"
    t.integer "age"
    t.string "sex"
    t.integer "aoo"
    t.string "ehi"
    t.string "ld"
    t.string "wada"
    t.string "fmriSide"
    t.string "csm"
    t.string "surgHemi"
    t.string "surgType"
    t.string "surgDesc"
    t.date "dos"
    t.integer "ilae"
    t.integer "engle"
    t.string "etiology"
    t.string "mri"
    t.string "surgHx"
    t.string "surgHxHemi"
    t.string "surgHxType"
    t.date "surgHxDate"
    t.date "preNpDoe"
    t.date "postNpDoe"
    t.integer "fsiq"
    t.string "english"
    t.string "vns"
    t.string "ecogHemi"
    t.string "ecog"
    t.date "implantDate"
    t.date "explantDate"
    t.integer "common"
    t.integer "commonRgb"
    t.integer "auditory"
    t.integer "audscramble"
    t.integer "rsvpCueNaming"
    t.integer "action"
    t.integer "perData3"
    t.integer "perData5"
    t.integer "perData7"
    t.integer "matchingAuditory"
    t.integer "matchingOrthographic"
    t.integer "matchingVisual"
    t.string "awakeCsm"
    t.string "awakeCsmTask"
    t.string "asleepCsm"
    t.string "asleepCsmTask"
    t.string "cceps"
    t.string "prime"
    t.string "thalamusStim"
    t.string "meg"
    t.string "rearranged"
    t.string "reimplant"
    t.string "reop"
    t.string "postOpMri"
    t.string "fmri"
    t.string "rns"
    t.string "dbs"
    t.date "dbsPhase2"
    t.string "dbsPostTest"
    t.string "combo"
    t.string "alice"
    t.string "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["master_patient_id"], name: "index_demographics_on_master_patient_id", unique: true
  end

  create_table "epilepsies", force: :cascade do |t|
    t.string "master_patient_id", null: false
    t.string "srno"
    t.string "epi"
    t.string "surname"
    t.string "name"
    t.date "dob"
    t.string "sex"
    t.integer "mhh"
    t.string "phase2"
    t.string "phase2implant"
    t.string "phase2explant"
    t.string "phase2duration"
    t.string "phase2complications"
    t.string "side"
    t.string "resection"
    t.string "surgery_type"
    t.string "adult"
    t.string "rxn_date"
    t.string "additional_intervention"
    t.string "lastfu"
    t.integer "fu"
    t.string "week6_engel"
    t.string "week6_ilae"
    t.string "month6_engel"
    t.string "month6_ilae"
    t.string "year1_engel"
    t.string "year1_ilae"
    t.string "year2_engel"
    t.string "year2_ilae"
    t.string "year3_engel"
    t.string "year3_ilae"
    t.string "year4_engel"
    t.string "year4_ilae"
    t.string "year5_engel"
    t.string "year5_ilae"
    t.string "year10_engel"
    t.string "year10_ilae"
    t.string "year11_engel"
    t.string "year11_ilae"
    t.string "year12_engel"
    t.string "year12_ilae"
    t.string "year13_engel"
    t.string "year13_ilae"
    t.string "year14_engel"
    t.string "year14_ilae"
    t.string "year15_engel"
    t.string "year15_ilae"
    t.string "notes"
    t.string "engel"
    t.string "ilae"
    t.string "meds_at_fu"
    t.string "med_names"
    t.string "post_rxn_ecog"
    t.string "ecog_results"
    t.string "prior_neurosurgery"
    t.string "add_notes"
    t.string "interictal_eeg"
    t.string "ictal_eeg"
    t.string "dominance"
    t.string "language_wada"
    t.string "memory_wada"
    t.string "wada_report_additional"
    t.string "meg"
    t.string "neuropsych_localization"
    t.string "viq"
    t.string "piq"
    t.string "fsiq"
    t.string "mri"
    t.string "pet"
    t.string "spect"
    t.string "co_morbidities"
    t.string "etiology"
    t.string "pathology"
    t.string "outcome"
    t.string "post_op_neuropsych"
    t.string "viq1"
    t.string "piq1"
    t.string "fsiq1"
    t.string "overall_result"
  end

  create_table "patient_tasks", force: :cascade do |t|
    t.string "master_patient_id", null: false
    t.string "task_name", null: false
    t.integer "task_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["master_patient_id"], name: "index_patient_tasks_on_master_patient_id"
    t.index ["task_name"], name: "index_patient_tasks_on_task_name"
  end

end
