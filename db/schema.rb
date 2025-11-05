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

ActiveRecord::Schema.define(version: 2024_10_07_191709) do

  create_table "action_logs", force: :cascade do |t|
    t.integer "user_id"
    t.integer "subject_id"
    t.string "subject_type"
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comments", force: :cascade do |t|
    t.integer "commentable_id"
    t.string "commentable_type"
    t.string "title"
    t.text "body"
    t.string "subject"
    t.integer "user_id", null: false
    t.integer "parent_id"
    t.integer "lft"
    t.integer "rgt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "data_dictionaries", force: :cascade do |t|
    t.string "field_name"
    t.text "description"
    t.string "data_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["field_name"], name: "index_data_dictionaries_on_field_name", unique: true
  end

  create_table "data_repositories", force: :cascade do |t|
    t.string "name"
    t.string "repository_url"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "project_id"
    t.integer "user_id"
    t.string "dr_type"
    t.index ["user_id", "name"], name: "index_data_repositories_on_user_id_and_name", unique: true
  end

  create_table "data_repository_records", force: :cascade do |t|
    t.integer "data_repository_id"
    t.integer "rppr_id"
    t.string "screenshot_evidence"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "desc"
    t.text "doi"
  end

  create_table "delegations", force: :cascade do |t|
    t.integer "project_pi_id"
    t.integer "pi_delegate_id"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "patients", force: :cascade do |t|
    t.string "subject"
    t.string "otherIDs"
    t.integer "age"
    t.string "sex"
    t.integer "onsetAge"
    t.string "handedness"
    t.string "domHemi"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "wada"
    t.string "fmri"
    t.string "csm"
    t.string "surgHemi"
    t.string "surgType"
    t.string "surgDescription"
    t.date "surgDate"
    t.integer "ilae"
    t.string "engel"
    t.string "etiology"
    t.string "mri"
    t.string "surgHx"
    t.string "surgHxHemi"
    t.string "surgHxType"
    t.date "surgHxDate"
    t.date "preNP_DOE"
    t.date "postNP_DOE"
    t.integer "fsiq"
    t.string "english"
    t.string "ecog_hemi"
    t.string "ecog"
    t.date "implantDate"
    t.date "explantDate"
    t.string "vns"
    t.string "prime"
    t.string "thalamusStim"
    t.string "meg"
    t.string "awakeCsm"
    t.string "awakeCsm_Tasks"
    t.string "asleepCsm"
    t.string "asleepCsm_Tasks"
  end

  create_table "projects", force: :cascade do |t|
    t.string "nih_spending_categorization"
    t.string "project_terms"
    t.string "project_title"
    t.string "public_health_relevance"
    t.string "administering_ic"
    t.string "application_id"
    t.date "award_notice_date"
    t.string "foa"
    t.string "project_number"
    t.string "type"
    t.string "activity"
    t.string "ic"
    t.string "serial_number"
    t.integer "support_year"
    t.string "suffix"
    t.text "program_official_information"
    t.date "project_start_date"
    t.date "project_end_date"
    t.string "study_section"
    t.string "sub_project_number"
    t.string "contact_pi_id"
    t.string "contact_pi"
    t.text "other_pis"
    t.string "congressional_district"
    t.string "department"
    t.string "primary_duns"
    t.string "primary_uei"
    t.string "duns_number"
    t.string "uei"
    t.string "fips"
    t.decimal "latitude"
    t.decimal "longitude"
    t.string "org_id"
    t.string "org_name"
    t.string "org_city"
    t.string "org_state"
    t.string "org_type"
    t.string "org_zip"
    t.string "org_country"
    t.string "arra_indicator"
    t.date "budget_start_date"
    t.date "budget_end_date"
    t.string "cfda_code"
    t.string "funding_mechanism"
    t.integer "fiscal_year"
    t.integer "total_cost"
    t.integer "total_cost_sub_project"
    t.string "funding_ic"
    t.string "direct_cost_id"
    t.string "indirect_cost_id"
    t.string "covid19_response"
    t.string "total_cost_ic"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "uthealth_primary_grantee"
    t.string "project_institution"
    t.string "public_starts_project_number"
    t.string "contact_pi_uthealth_id"
    t.string "contact_pi_era_id"
    t.string "nhash_id"
    t.string "pi_email"
    t.string "granting_agency"
    t.string "dms_plan_file_name"
    t.string "dms_plan_file"
    t.string "status", default: "active"
    t.integer "dms_status", default: 1
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "privilege_string"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rpprs", force: :cascade do |t|
    t.integer "project_id"
    t.integer "year_start"
    t.integer "year_end"
    t.text "abstract"
    t.integer "data_repository_id"
    t.string "supplemental_info"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 1
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "due_date"
    t.boolean "data_repository_na", default: false
    t.boolean "data_change"
    t.text "data_change_description"
  end

  create_table "terminologies", force: :cascade do |t|
    t.string "variable_name"
    t.string "field_name"
    t.string "description"
    t.string "data_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_roles", force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "user_firstname"
    t.string "user_lastname"
    t.string "user_middlename"
    t.string "user_login"
    t.integer "user_type_id"
    t.string "user_title"
    t.string "token"
    t.boolean "approved"
    t.string "degree"
    t.string "avatar"
    t.string "signature"
    t.string "middle_name"
    t.string "status", default: "active"
    t.string "password_digest"
    t.string "email"
    t.boolean "pediatric"
    t.integer "center_id"
    t.string "institution"
    t.integer "sequencing_center_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_firstname", "user_lastname"], name: "index_users_on_user_firstname_and_user_lastname", unique: true
  end

end
