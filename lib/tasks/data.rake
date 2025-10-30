namespace :data do
  desc "Map studies to master patients"
  task import_study_mappings: :environment do
    MasterPatient.find_each do |master_patient|
      studies = {
        "patient_demographics" => ["subject"],
        "epilepsy_data" => ["local_patient_id"],
        "seeg_data" => ["mrn"]
      }

      studies.each do |table_name, identifier_columns|
        identifier_columns.each do |identifier_column|
          if identifier_column == "subject"
            sql = <<-SQL
              INSERT INTO patient_mappings (subject, local_patient_id, study_table_name, created_at, updated_at)
              SELECT ?, #{identifier_column}, ?, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP 
              FROM #{table_name} WHERE #{identifier_column} LIKE ?
            SQL
            ActiveRecord::Base.connection.execute(
              ActiveRecord::Base.sanitize_sql_array([sql, master_patient.subject, table_name, "#{master_patient.subject}%"])
            )
          elsif identifier_column == "local_patient_id"
            sql = <<-SQL
              INSERT INTO patient_mappings (subject, local_patient_id, study_table_name, created_at, updated_at)
              SELECT ?, #{identifier_column}, ?, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
              FROM #{table_name} WHERE #{identifier_column} = ?
            SQL
            ActiveRecord::Base.connection.execute(
              ActiveRecord::Base.sanitize_sql_array([sql, master_patient.subject, table_name, master_patient.subject])
            )    
          elsif identifier_column == "mrn"
            sql = <<-SQL
              INSERT INTO patient_mappings (subject, local_patient_id, study_table_name, created_at, updated_at)
              SELECT ?, #{identifier_column}, ?, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
              FROM #{table_name} WHERE #{identifier_column} = ?
            SQL
            ActiveRecord::Base.connection.execute(
              ActiveRecord::Base.sanitize_sql_array([sql, master_patient.subject, table_name, master_patient.mrn])
            )
          end
        end
      end
    end

    puts "All Study Mapping have been updated"
  end

  desc "Map Local Term to Common Data Elements (CDEs)"
  task map_cdes: :environment do
    sql = <<-SQL
      UPDATE local_terminologies
      SET cde_id = (
        SELECT code FROM cdes WHERE cdes.code = local_terminologies.cde_id
      )
      WHERE EXISTS (
        SELECT 1 FROM cdes WHERE cdes.code = local_terminologies.cde_id
      )
    SQL

    ActiveRecord::Base.connection.execute(sql)

    puts "CDE Mapping process completed."
  end

  desc "Import tasks from task_assignments and associate with master patients"
  task import_tasks: :environment do
    imported = 0
    skipped = 0

    TaskAssignment.find_each do |assignment|
      subject_id = assignment.subject_id.to_s.strip.upcase

      master_patient = MasterPatient.find_by("UPPER(TRIM(subject)) = ?", subject_id)

      if master_patient
        task = Task.new(
          name: assignment.task_name,
          count: assignment.count,
          master_patient_id: master_patient.id
        )
        if task.save
          imported += 1
        else
          skipped += 1
          puts "Validation failed for task: '#{task.errors.full_messages.join(', ')}'"
        end
      else
        skipped += 1
        puts "No MasterPatient found for subject_id: '#{assignment.subject_id}'"
      end
    end 

    puts "Imported #{imported}, Skipped: #{skipped}"
  end
end


  