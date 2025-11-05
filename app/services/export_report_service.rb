require 'csv'

class ExportReportService
  def initialize(relation, columns = [], name = 'report', user = nil)
    @relation = relation
    @columns  = Array(columns)
    @name     = name.to_s.presence || 'report'
    @user     = user
  end

  def to_csv
    CSV.generate(headers: true) do |csv|
      headers = @columns.map { |c| humanize_alias(c) }
      csv << headers

      @relation.each do |record|
        row = @columns.map do |col|

          record.attributes.fetch(col, nil)
        end
        csv << row
      end
    end
  end

  def filename
    "#{@name.parameterize}_#{Time.now.strftime('%Y%m%d_%H%M%S')}"
  end

  private

  def humanize_alias(alias_name)
    # convert 'patient_tasks__task_name' -> 'patient_tasks.task_name'
    alias_name.to_s.gsub('__', '.')
  end
end

