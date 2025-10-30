class PatientTask < ApplicationRecord
  validates :master_patient_id, :task_name, presence: true
  validates :task_count, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true

  scope :by_patient, ->(id) { where(master_patient_id: id.upcase) }
  scope :by_task, ->(name) { where(task_name: name.downcase) }

  scope :with_cohort_prefix, ->(prefixes) {
    return none if prefixes.blank?
    patterns = Array(prefixes).map { |p| "#{p.to_s.upcase}%"}
    where(patterns.map { 'master_patient_id LIKE ?' }.join(' OR '), *patterns)
  }
  
  scope :with_task_names, ->(names) {
    return all if names.blank?
    where('LOWER(task_name) IN (?)', Array(names).map(&:downcase))
  }

  def self.join_demographics
    joins('INNER JOIN demographics ON demographics.master_patient_id = patient_tasks.master_patient_id')
  end

  def self.join_epilepsy
    joins('INNER JOIN epilepsy ON epilepsy.master_patient_id = patient_tasks.master_patient_id')
  end

  def self.join_ccep
    joins('INNER JOIN ccep ON ccep.master_patient_id = patient_tasks.master_patient_id')
  end

  def self.import(file_path)
    sheet = Roo::Spreadsheet.open(file_path.to_s).sheet(0)
    header = sheet.row(1).map(&:to_s)

    imported = 0
    updated  = 0
    skipped  = 0

    db_columns = PatientTask.column_names - ["id", "created_at", "updated_at"]

    (2..sheet.last_row).each do |i|
      row = Hash[[header, sheet.row(i)].transpose]
      base_id = normalize_id(row["master_patient_id"])
      task_name = row["task_name"]&.strip
      next unless base_id.present?

      patient_task = PatientTask.find_by("UPPER(master_patient_id) = ? AND LOWER(task_name) = ?", base_id.upcase, task_name.downcase)

      filtered_row = row.stringify_keys.slice(*db_columns)
      filtered_row["master_patient_id"] = base_id
      filtered_row["task_name"] = task_name

      if patient_task
        existing_attrs = patient_task.attributes.slice(*db_columns)

        if existing_attrs.transform_values { |v| v.to_s.strip } != filtered_row.transform_values { |v| v.to_s.strip }
          patient_task.update!(filtered_row)
          updated += 1
        else
          skipped += 1
        end
      else
        PatientTask.create!(filtered_row)
        imported += 1
      end
    end

    { imported: imported, updated: updated, skipped: skipped }
  end

  private

  def self.normalize_id(raw_id)
    return nil unless raw_id
    raw_id.to_s.strip.upcase.gsub(/[^A-Z0-9]/, '')
  end
end