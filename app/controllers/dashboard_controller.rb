class DashboardController < ApplicationController
  def index
    # Cohort distribution
    raw_counts = Demographic.group("SUBSTR(master_patient_id, 1, 2)").count

    @cohort_counts = raw_counts.each_with_object(Hash.new(0)) do |(cohort, count), result|
      if count >= 10
        result[cohort] = count
      else
        result["Other"] += count
      end
    end

    # Category
    cohort_category_map = {
      "TA" => "Clinical", "TB" => "Clinical", "TC" => "Clinical", "TS" => "Clinical",
      "TE" => "Research", "TT" => "Research"
    }

    @category_counts = Hash.new(0)
    raw_counts.each do |cohort, count|
      category = cohort_category_map[cohort] || "Other"
      @category_counts[category] += count
    end

    # Age distribution
    @age_distribution = Demographic.group(
      Arel.sql("CASE 
        WHEN age < 18 THEN '<18'
        WHEN age BETWEEN 18 AND 30 THEN '18-30'
        WHEN age BETWEEN 31 AND 50 THEN '31-50'
        ELSE '51+' END")
    ).count

    # Top 10 tasks
    @top_tasks = PatientTask
      .group(:task_name)
      .order("COUNT(*) DESC")
      .limit(10)
      .count
  end
end