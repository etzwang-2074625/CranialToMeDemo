class Ccep < ApplicationRecord
  def self.import(file_path)
    sheet = Roo::Spreadsheet.open(file_path.to_s).sheet(0)
    header = sheet.row(1).map(&:to_s)
    header = sheet.row(1).map(&:to_s)

    imported = 0
    updated  = 0
    skipped  = 0

    db_columns = Ccep.column_names - %w[id created_at updated_at]

    (2..sheet.last_row).each do |i|
      row = Hash[[header, sheet.row(i)].transpose]

      base_id   = normalize_id(row["master_patient_id"])
      anode     = row["anode"]&.strip&.upcase
      amplitude = row["ccep_amplitude"]&.to_s&.strip
      sector_fn = row["sector_1_file_name"]&.to_s&.strip
      time_val  = row["time"]&.to_s&.strip

      next unless base_id.present?

      filtered_row = row.stringify_keys.slice(*db_columns)
      filtered_row["master_patient_id"]  = base_id
      filtered_row["anode"]              = anode
      filtered_row["ccep_amplitude"]     = amplitude
      filtered_row["sector_1_file_name"] = sector_fn
      filtered_row["time"]               = time_val

      query = Ccep.where("UPPER(master_patient_id) = ?", base_id)

      if anode.present?
        query = query.where("UPPER(anode) = ?", anode)
      else
        query = query.where("anode IS NULL")
      end

      query = query.where(
        "(ccep_amplitude = ? OR (ccep_amplitude IS NULL AND ? IS NULL))",
        amplitude.presence,
        amplitude.presence
      )

      query = query.where(
        "(sector_1_file_name = ? OR (sector_1_file_name IS NULL AND ? IS NULL))",
        sector_fn.presence,
        sector_fn.presence
      )

      query = query.where(
        "(time = ? OR (time IS NULL AND ? IS NULL))",
        time_val.presence,
        time_val.presence
      )

      ccep = query.first

      if ccep
        existing_attrs = ccep.attributes.slice(*db_columns)
        if existing_attrs.transform_values { |v| v.to_s.strip } != filtered_row.transform_values { |v| v.to_s.strip }
          ccep.update!(filtered_row)
          updated += 1
        else
          skipped += 1
        end
      else
        Ccep.create!(filtered_row)
        imported += 1
      end
    end

    { imported: imported, updated: updated, skipped: skipped }
  end

  private

  def self.normalize_id(raw_id)
    return nil unless raw_id
    raw_id.to_s.strip.upcase.gsub(/[^A-Z0-9]/, "")
  end
end



  
