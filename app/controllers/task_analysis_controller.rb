class TaskAnalysisController < ApplicationController
  def preview
    raw_blocks   = params[:query_blocks] || params[:blocks] || []
    query_blocks = normalize_query_blocks(raw_blocks)

    Rails.logger.debug("NORMALIZED BLOCKS: #{query_blocks.inspect}")
    qb = QueryBuilder.new(query_blocks)
    results = qb.run

    @merged_data = results.limit(200)
    @selected_columns = qb.selected_aliases
    @name = params[:name].presence || "Preview"

    render :preview
  end

  def export
    raw_blocks   = params[:query_blocks] || params[:blocks] || []
    query_blocks = normalize_query_blocks(raw_blocks)

    qb = QueryBuilder.new(query_blocks)
    results = qb.run

    columns = qb.selected_aliases
    service = ExportReportService.new(results, columns, params[:name] || 'report')
    send_data service.to_csv, filename: "#{service.filename}.csv", type: 'text/csv'
  end

  private

  def normalize_query_blocks(raw_blocks)
    Array(raw_blocks).map do |b|
      table = (b['table'] || b[:table]).to_s
      field = (b['field'] || b[:field]).to_s
      op    = (b['operator'] || b[:operator]).to_s
      val   = b['value'] || b[:value]

      numeric_fields = %w[age task_count aoo phase2duration]
      date_fields    = %w[dob dos date_tested phase2implant phase2explant rxn_date]
      boolean_fields = %w[adult]

      value = if val.blank?
                nil
              elsif numeric_fields.include?(field)
                val.to_i
              elsif date_fields.include?(field)
                parse_date(val) || val
              elsif boolean_fields.include?(field)
                if val.to_s.downcase.in?(%w[yes true 1 y])
                  1
                elsif val.to_s.downcase.in?(%w[no false 0 n])
                  0
                else
                  val
                end
              else
                val.to_s.strip
              end

      { "table" => table, "field" => field, "operator" => op, "value" => value }
    end.compact
  end

  def parse_date(val)
    return nil if val.blank?
    Date.parse(val) rescue nil
  end
end


