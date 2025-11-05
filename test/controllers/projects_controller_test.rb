require 'test_helper'

class ProjectsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @project = projects(:one)
  end

  test "should get index" do
    get projects_url
    assert_response :success
  end

  test "should get new" do
    get new_project_url
    assert_response :success
  end

  test "should create project" do
    assert_difference('Project.count') do
      post projects_url, params: { project: { activity: @project.activity, administering_ic: @project.administering_ic, application_id: @project.application_id, arra_indicator: @project.arra_indicator, award_notice_date: @project.award_notice_date, budget_end_date: @project.budget_end_date, budget_start_date: @project.budget_start_date, cfda_code: @project.cfda_code, congressional_district: @project.congressional_district, contact_pi: @project.contact_pi, contact_pi_id: @project.contact_pi_id, covid19_response: @project.covid19_response, department: @project.department, direct_cost_id: @project.direct_cost_id, duns_number: @project.duns_number, fips: @project.fips, fiscal_year: @project.fiscal_year, foa: @project.foa, funding_ic: @project.funding_ic, funding_mechanism: @project.funding_mechanism, ic: @project.ic, indirect_cost_id: @project.indirect_cost_id, latitude: @project.latitude, longitude: @project.longitude, nih_spending_categorization: @project.nih_spending_categorization, org_city: @project.org_city, org_country: @project.org_country, org_id: @project.org_id, org_name: @project.org_name, org_state: @project.org_state, org_type: @project.org_type, org_zip: @project.org_zip, other_pis: @project.other_pis, primary_duns: @project.primary_duns, primary_uei: @project.primary_uei, program_official_information: @project.program_official_information, project_end_date: @project.project_end_date, project_number: @project.project_number, project_start_date: @project.project_start_date, project_terms: @project.project_terms, project_title: @project.project_title, public_health_relevance: @project.public_health_relevance, serial_number: @project.serial_number, study_section: @project.study_section, sub_project_number: @project.sub_project_number, suffix: @project.suffix, support_year: @project.support_year, total_cost: @project.total_cost, total_cost_ic: @project.total_cost_ic, total_cost_sub_project: @project.total_cost_sub_project, type: @project.type, uei: @project.uei } }
    end

    assert_redirected_to project_url(Project.last)
  end

  test "should show project" do
    get project_url(@project)
    assert_response :success
  end

  test "should get edit" do
    get edit_project_url(@project)
    assert_response :success
  end

  test "should update project" do
    patch project_url(@project), params: { project: { activity: @project.activity, administering_ic: @project.administering_ic, application_id: @project.application_id, arra_indicator: @project.arra_indicator, award_notice_date: @project.award_notice_date, budget_end_date: @project.budget_end_date, budget_start_date: @project.budget_start_date, cfda_code: @project.cfda_code, congressional_district: @project.congressional_district, contact_pi: @project.contact_pi, contact_pi_id: @project.contact_pi_id, covid19_response: @project.covid19_response, department: @project.department, direct_cost_id: @project.direct_cost_id, duns_number: @project.duns_number, fips: @project.fips, fiscal_year: @project.fiscal_year, foa: @project.foa, funding_ic: @project.funding_ic, funding_mechanism: @project.funding_mechanism, ic: @project.ic, indirect_cost_id: @project.indirect_cost_id, latitude: @project.latitude, longitude: @project.longitude, nih_spending_categorization: @project.nih_spending_categorization, org_city: @project.org_city, org_country: @project.org_country, org_id: @project.org_id, org_name: @project.org_name, org_state: @project.org_state, org_type: @project.org_type, org_zip: @project.org_zip, other_pis: @project.other_pis, primary_duns: @project.primary_duns, primary_uei: @project.primary_uei, program_official_information: @project.program_official_information, project_end_date: @project.project_end_date, project_number: @project.project_number, project_start_date: @project.project_start_date, project_terms: @project.project_terms, project_title: @project.project_title, public_health_relevance: @project.public_health_relevance, serial_number: @project.serial_number, study_section: @project.study_section, sub_project_number: @project.sub_project_number, suffix: @project.suffix, support_year: @project.support_year, total_cost: @project.total_cost, total_cost_ic: @project.total_cost_ic, total_cost_sub_project: @project.total_cost_sub_project, type: @project.type, uei: @project.uei } }
    assert_redirected_to project_url(@project)
  end

  test "should destroy project" do
    assert_difference('Project.count', -1) do
      delete project_url(@project)
    end

    assert_redirected_to projects_url
  end
end
