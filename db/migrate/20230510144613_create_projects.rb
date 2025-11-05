class CreateProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :projects do |t|
      t.string :nih_spending_categorization
      t.string :project_terms
      t.string :project_title
      t.string :public_health_relevance
      t.string :administering_ic
      t.string :application_id
      t.date :award_notice_date
      t.string :foa
      t.string :project_number
      t.string :type
      t.string :activity
      t.string :ic
      t.string :serial_number
      t.integer :support_year
      t.string :suffix
      t.text :program_official_information
      t.date :project_start_date
      t.date :project_end_date
      t.string :study_section
      t.string :sub_project_number
      t.string :contact_pi_id
      t.string :contact_pi
      t.text :other_pis
      t.string :congressional_district
      t.string :department
      t.string :primary_duns
      t.string :primary_uei
      t.string :duns_number
      t.string :uei
      t.string :fips
      t.decimal :latitude
      t.decimal :longitude
      t.string :org_id
      t.string :org_name
      t.string :org_city
      t.string :org_state
      t.string :org_type
      t.string :org_zip
      t.string :org_country
      t.string :arra_indicator
      t.date :budget_start_date
      t.date :budget_end_date
      t.string :cfda_code
      t.string :funding_mechanism
      t.integer :fiscal_year
      t.integer :total_cost
      t.integer :total_cost_sub_project
      t.string :funding_ic
      t.string :direct_cost_id
      t.string :indirect_cost_id
      t.string :covid19_response
      t.string :total_cost_ic

      t.timestamps
    end
  end
end
