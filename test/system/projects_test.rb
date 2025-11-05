require "application_system_test_case"

class ProjectsTest < ApplicationSystemTestCase
  setup do
    @project = projects(:one)
  end

  test "visiting the index" do
    visit projects_url
    assert_selector "h1", text: "Projects"
  end

  test "creating a Project" do
    visit projects_url
    click_on "New Project"

    fill_in "Activity", with: @project.activity
    fill_in "Administering ic", with: @project.administering_ic
    fill_in "Application", with: @project.application_id
    fill_in "Arra indicator", with: @project.arra_indicator
    fill_in "Award notice date", with: @project.award_notice_date
    fill_in "Budget end date", with: @project.budget_end_date
    fill_in "Budget start date", with: @project.budget_start_date
    fill_in "Cfda code", with: @project.cfda_code
    fill_in "Congressional district", with: @project.congressional_district
    fill_in "Contact pi", with: @project.contact_pi
    fill_in "Contact pi", with: @project.contact_pi_id
    fill_in "Covid19 response", with: @project.covid19_response
    fill_in "Department", with: @project.department
    fill_in "Direct cost", with: @project.direct_cost_id
    fill_in "Duns number", with: @project.duns_number
    fill_in "Fips", with: @project.fips
    fill_in "Fiscal year", with: @project.fiscal_year
    fill_in "Foa", with: @project.foa
    fill_in "Funding ic", with: @project.funding_ic
    fill_in "Funding mechanism", with: @project.funding_mechanism
    fill_in "Ic", with: @project.ic
    fill_in "Indirect cost", with: @project.indirect_cost_id
    fill_in "Latitude", with: @project.latitude
    fill_in "Longitude", with: @project.longitude
    fill_in "Nih spending categorization", with: @project.nih_spending_categorization
    fill_in "Org city", with: @project.org_city
    fill_in "Org country", with: @project.org_country
    fill_in "Org", with: @project.org_id
    fill_in "Org name", with: @project.org_name
    fill_in "Org state", with: @project.org_state
    fill_in "Org type", with: @project.org_type
    fill_in "Org zip", with: @project.org_zip
    fill_in "Other pis", with: @project.other_pis
    fill_in "Primary duns", with: @project.primary_duns
    fill_in "Primary uei", with: @project.primary_uei
    fill_in "Program official information", with: @project.program_official_information
    fill_in "Project end date", with: @project.project_end_date
    fill_in "Project number", with: @project.project_number
    fill_in "Project start date", with: @project.project_start_date
    fill_in "Project terms", with: @project.project_terms
    fill_in "Project title", with: @project.project_title
    fill_in "Public health relevance", with: @project.public_health_relevance
    fill_in "Serial number", with: @project.serial_number
    fill_in "Study section", with: @project.study_section
    fill_in "Sub project number", with: @project.sub_project_number
    fill_in "Suffix", with: @project.suffix
    fill_in "Support year", with: @project.support_year
    fill_in "Total cost", with: @project.total_cost
    fill_in "Total cost ic", with: @project.total_cost_ic
    fill_in "Total cost sub project", with: @project.total_cost_sub_project
    fill_in "Type", with: @project.type
    fill_in "Uei", with: @project.uei
    click_on "Create Project"

    assert_text "Project was successfully created"
    click_on "Back"
  end

  test "updating a Project" do
    visit projects_url
    click_on "Edit", match: :first

    fill_in "Activity", with: @project.activity
    fill_in "Administering ic", with: @project.administering_ic
    fill_in "Application", with: @project.application_id
    fill_in "Arra indicator", with: @project.arra_indicator
    fill_in "Award notice date", with: @project.award_notice_date
    fill_in "Budget end date", with: @project.budget_end_date
    fill_in "Budget start date", with: @project.budget_start_date
    fill_in "Cfda code", with: @project.cfda_code
    fill_in "Congressional district", with: @project.congressional_district
    fill_in "Contact pi", with: @project.contact_pi
    fill_in "Contact pi", with: @project.contact_pi_id
    fill_in "Covid19 response", with: @project.covid19_response
    fill_in "Department", with: @project.department
    fill_in "Direct cost", with: @project.direct_cost_id
    fill_in "Duns number", with: @project.duns_number
    fill_in "Fips", with: @project.fips
    fill_in "Fiscal year", with: @project.fiscal_year
    fill_in "Foa", with: @project.foa
    fill_in "Funding ic", with: @project.funding_ic
    fill_in "Funding mechanism", with: @project.funding_mechanism
    fill_in "Ic", with: @project.ic
    fill_in "Indirect cost", with: @project.indirect_cost_id
    fill_in "Latitude", with: @project.latitude
    fill_in "Longitude", with: @project.longitude
    fill_in "Nih spending categorization", with: @project.nih_spending_categorization
    fill_in "Org city", with: @project.org_city
    fill_in "Org country", with: @project.org_country
    fill_in "Org", with: @project.org_id
    fill_in "Org name", with: @project.org_name
    fill_in "Org state", with: @project.org_state
    fill_in "Org type", with: @project.org_type
    fill_in "Org zip", with: @project.org_zip
    fill_in "Other pis", with: @project.other_pis
    fill_in "Primary duns", with: @project.primary_duns
    fill_in "Primary uei", with: @project.primary_uei
    fill_in "Program official information", with: @project.program_official_information
    fill_in "Project end date", with: @project.project_end_date
    fill_in "Project number", with: @project.project_number
    fill_in "Project start date", with: @project.project_start_date
    fill_in "Project terms", with: @project.project_terms
    fill_in "Project title", with: @project.project_title
    fill_in "Public health relevance", with: @project.public_health_relevance
    fill_in "Serial number", with: @project.serial_number
    fill_in "Study section", with: @project.study_section
    fill_in "Sub project number", with: @project.sub_project_number
    fill_in "Suffix", with: @project.suffix
    fill_in "Support year", with: @project.support_year
    fill_in "Total cost", with: @project.total_cost
    fill_in "Total cost ic", with: @project.total_cost_ic
    fill_in "Total cost sub project", with: @project.total_cost_sub_project
    fill_in "Type", with: @project.type
    fill_in "Uei", with: @project.uei
    click_on "Update Project"

    assert_text "Project was successfully updated"
    click_on "Back"
  end

  test "destroying a Project" do
    visit projects_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Project was successfully destroyed"
  end
end
