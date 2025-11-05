task adjust_dateformat: [:environment] do
  project_count = Project.count
  puts "number of projects to update = #{project_count}"

  Project.all.to_a.each do |project|
    puts "***** Original: project.id = #{project.id}, project_start_date = #{project.project_start_date}, project_end_date = #{project.project_end_date} *******"
    new_start_date = Date.strptime(project.project_start_date.strftime('%m/%d/%y'),"%m/%d/%y")
    new_end_date = Date.strptime(project.project_end_date.strftime('%m/%d/%y'),"%m/%d/%y")
    puts "Updated --> new_start_date = #{new_start_date}, new_end_date = #{new_end_date}"

    project.project_start_date = new_start_date
    project.project_end_date = new_end_date
    project.save!
  rescue => e
    puts "ERROR: project.id = #{project.id}"
    puts "e.message = #{e.message}"
  end
end
