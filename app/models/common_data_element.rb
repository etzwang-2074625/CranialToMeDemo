class CommonDataElement < ApplicationRecord
  validates :element_name, presence: true

  def self.import(file_path)
    sheet = Roo::Spreadsheet.open(file_path.to_s).sheet(0)
    header = sheet.row(1).map(&:to_s).map(&:underscore)

    imported = 0
    skipped = 0

    db_columns = CommonDataElement.column_names

    (2..sheet.last_row).each do |i|
      row = Hash[[header, sheet.row(i)].transpose]
      row = row.stringify_keys.slice(*db_columns)

      element_name = row["element_name"].to_s.strip
      next if element_name.blank?

      if CommonDataElement.exists?(element_name: element_name)
        skipped += 1
        next
      end

      cde = CommonDataElement.new(row)
      if cde.save
        imported += 1
      else
        skipped += 1
      end
    end

    { imported: imported, skipped: skipped }
  end
end
