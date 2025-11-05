class Epilepsy < ApplicationRecord
  belongs_to :demographic, foreign_key: :master_patient_id, primary_key: :master_patient_id, optional: true
  has_many   :patient_tasks, foreign_key: :master_patient_id, primary_key: :master_patient_id
  
  validates :master_patient_id, presence: true, uniqueness: true

  def self.import(file_path)
    sheet = Roo::Spreadsheet.open(file_path.to_s).sheet(0)
    header = sheet.row(1).map(&:to_s).map(&:underscore)

    imported = 0
    updated = 0
    skipped = 0

    db_columns = Epilepsy.column_names - ["id", "created_at", "updated_at"]

    (2..sheet.last_row).each do |i|
      row = Hash[[header, sheet.row(i)].transpose]
      base_id = normalize_id(row["master_patient_id"])
      next unless base_id.present?

      epilepsy = Epilepsy.find_by("UPPER(master_patient_id) = ?", base_id.upcase)

      filtered_row = row.stringify_keys.slice(*db_columns)
      filtered_row["master_patient_id"] = base_id

      if epilepsy
        existing_attrs = epilepsy.attributes.slice(*db_columns)
        
        if existing_attrs.transform_values(&:to_s) != filtered_row.transform_values(&:to_s)
          epilepsy.update(filtered_row)
          updated += 1
        else
          skipped += 1
        end
      else
        Epilepsy.create!(filtered_row)
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

  
