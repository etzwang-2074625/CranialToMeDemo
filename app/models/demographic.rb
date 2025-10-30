class Demographic < ApplicationRecord
  before_validation :normalize_master_patient_id

  validates :master_patient_id, presence: true, uniqueness: true

  scope :age_leq, ->(v) { where('age <= ?', v.to_i) if v.present? }
  scope :age_geq, ->(v) { where('age >= ?', v.to_i) if v.present? }

  def self.import(file_path)
    sheet = Roo::Spreadsheet.open(file_path.to_s).sheet(0)
    header = sheet.row(1).map(&:to_s)

    imported = 0
    updated  = 0
    skipped  = 0

    db_columns = Demographic.column_names - ["id", "created_at", "updated_at"]

    (2..sheet.last_row).each do |i|
      row = Hash[[header, sheet.row(i)].transpose]
      base_id = normalize_id(row["master_patient_id"])
      next unless base_id.present?

      demographic = Demographic.find_by("UPPER(master_patient_id) = ?", base_id.upcase)

      filtered_row = row.stringify_keys.slice(*db_columns)
      filtered_row["master_patient_id"] = base_id

      if demographic
        existing_attrs = demographic.attributes.slice(*db_columns)

        if existing_attrs.transform_values(&:to_s) != filtered_row.transform_values(&:to_s)
          demographic.update!(filtered_row)
          updated += 1
        else
          skipped += 1
        end
      else
        Demographic.create!(filtered_row)
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

  def normalize_master_patient_id
    self.master_patient_id = master_patient_id.to_s.strip.upcase if master_patient_id.present?
  end
end

  
