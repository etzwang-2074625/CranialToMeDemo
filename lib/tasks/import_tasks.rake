require 'roo'

namespace :import do
  desc "Import task counts from Excel and associate them with subjects"
  task tasks: :environment do
    file_path = Rails.root.join('path', 'to', 'task_intersection_final.xlsx')

    unless File.exist?(file_path)
      puts "File not found: #{file_path}"
      exit
    end

    puts "Opening file: #{file_path}"
    spreadsheet = Roo::Spreadsheet.open(file_path)

    subject_ids = spreadsheet.row(1)[1..].map(&:strip)

    created_count = 0
    updated_count = 0
    missing_subjects = []

    (2..spreadsheet.last_row).each do |i|
      row = spreadsheet.row(i)
      task_name = row.first&.strip
      next unless task_name.present?

      task = Task.find_or_create_by!(name: task_name)

      row[1..].each_with_index do |count, idx|
        next if count.to_i <= 0

        subject_id = subject-ids[idx]
        patient = MasterPatient.find_by(subject_id: subject_id)

        unless patient
          missing_subjects << subject_id unless missing_subjects.include?(subject_id)
          next
        end

        subject_task = SubjectTask.find_or_initalize_by(master_patient: patient, task: task)
        if subject_task.new_record?
          subject_task.count = count.to_i
          created_count += 1
        else
          subject_task.count = count.to_i
          updated_count += 1
        end
        subject_task.save!
      end 
    end

    most_common = Task.joins(:subject_tasks)
                   .group('task.id')
                   .select('tasks.*, SUM(subject_tasks.count) as total_count')
                   .order('total_count DESC')
                   .first
  end
end 