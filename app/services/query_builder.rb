class QueryBuilder
  FIELD_WHITELIST = {
    "patient_tasks" => {
      "task_name"  => [:contains, :not_contains],
      "task_count" => [:equals, :gte, :lte],
      "date_tested"=> [:before, :after]
    },
    "demographics" => {
      "age"        => [:equals, :gte, :lte],
      "sex"        => [:contains, :not_contains],
      "dob"        => [:before, :after],
      "aoo"        => [:equals, :gte, :lte],
      "ehi"        => [:contains, :not_contains],
      "ld"         => [:contains, :not_contains],
      "wada"       => [:contains, :not_contains],
      "fmriSide"   => [:contains, :not_contains],
      "csm"        => [:contains, :not_contains],
      "surgHemi"   => [:contains, :not_contains],
      "surgType"   => [:contains, :not_contains],
      "surgDesc"   => [:contains, :not_contains],
      "dos"        => [:before, :after],
      "ilae"       => [:contains, :not_contains],
      "engle"      => [:contains, :not_contains],
      "etiology"   => [:contains, :not_contains],
      "mri"        => [:contains, :not_contains]
    },
    "epilepsies" => {
      "phase2"                  => [:contains, :not_contains],
      "phase2implant"           => [:before, :after],
      "phase2explant"           => [:before, :after],
      "phase2duration"          => [:contains, :not_contains, :gte, :lte],
      "phase2complication"      => [:contains, :not_contains],
      "side"                    => [:contains, :not_contains],
      "resection"               => [:contains, :not_contains],
      "surgery_type"            => [:contains, :not_contains],
      "adult"                   => [:equals, :contains, :not_contains],
      "rxn_date"                => [:before, :after],
      "additional_intervention" => [:contains, :not_contains],
      "notes"                   => [:all, :contains]
    },
    "cceps" => {
      "date"           => [:before, :after],
      "csm_notes"      => [:all, :contains],
      "hemisphere"     => [:contains, :not_contains],
      "seeg_or_sde"    => [:contains, :not_contains],
      "anode"          => [:contains, :not_contains],
      "cathode"       => [:contains, :not_contains],
      "ccep_amplitude" => [:contains, :not_contains],
      "notes"      => [:all, :contains]

    }
  }.freeze

  TABLE_MODELS = {
    "demographics"  => Demographic,
    "patient_tasks" => PatientTask,
    "epilepsies"    => Epilepsy,
    "cceps"         => Ccep
  }.freeze

  BASE_TABLE = "demographics"

  attr_reader :selected_aliases

  def initialize(query_blocks)
    @query_blocks = Array(query_blocks)
    @selected_aliases = []   
  end

  def run
    scope   = TABLE_MODELS[BASE_TABLE].all
    joined  = {}
    selects = []

    selects << "#{BASE_TABLE}.id AS #{BASE_TABLE}__id"
    selects << "#{BASE_TABLE}.master_patient_id AS #{BASE_TABLE}__master_patient_id"
    @selected_aliases = ["#{BASE_TABLE}__master_patient_id"] # default column list (for export/preview)

    # apply multiple filters to same field
    filters = Hash.new { |h, k| h[k] = [] }

    @query_blocks.each do |block|
      table    = block["table"].to_s
      field    = block["field"].to_s
      operator = block["operator"].to_s
      value    = block["value"]

      unless valid_field?(table, field, operator)
        Rails.logger.debug("[QueryBuilder] skipping invalid block: #{block.inspect}")
        next
      end

      # left join other tables to demographics if needed
      if table != BASE_TABLE && !joined[table]
        join_sql = "LEFT JOIN #{table} ON UPPER(#{table}.master_patient_id) = UPPER(#{BASE_TABLE}.master_patient_id)"
        scope = scope.joins(join_sql)
        joined[table] = true
      end

      # add aliased select
      alias_name = "#{table}__#{field}"
      select_expr = "#{table}.#{field} AS #{alias_name}"
      unless selects.include?(select_expr)
        selects << select_expr
      end
      unless @selected_aliases.include?(alias_name)
        @selected_aliases << alias_name
      end

      # stash the condition
      filters[[table, field]] << { operator: operator, value: value }
    end

    filters.each do |(table, field), conditions|
      conditions.each do |cond|
        scope = apply_filter(scope, table, field, cond[:operator], cond[:value])
      end
    end

    # build final
    scope = scope.select((["#{BASE_TABLE}.id AS #{BASE_TABLE}__id", "#{BASE_TABLE}.master_patient_id AS #{BASE_TABLE}__master_patient_id"] + selects).uniq.join(", "))
    scope = scope.distinct
    Rails.logger.debug("[QueryBuilder] SQL: #{scope.to_sql}")
    scope
  end

  private

  def valid_field?(table, field, operator)
    FIELD_WHITELIST.key?(table) &&
      FIELD_WHITELIST[table].key?(field) &&
      FIELD_WHITELIST[table][field].map(&:to_sym).include?(operator.to_sym)
  end

  def apply_filter(scope, table, field, operator, value)
    qualified = "#{table}.#{field}"
    case operator.to_sym
    when :contains
      scope.where("LOWER(#{qualified}) LIKE ?", "%#{value.to_s.downcase}%")
    when :not_contains
      scope.where.not("LOWER(#{qualified}) LIKE ?", "%#{value.to_s.downcase}%")
    when :equals
      scope.where(qualified => value)
    when :gte
      scope.where("#{qualified} >= ?", value)
    when :lte
      scope.where("#{qualified} <= ?", value)
    when :before
      scope.where("#{qualified} < ?", value)
    when :after
      scope.where("#{qualified} > ?", value)
    when :all
      scope
    else
      scope
    end
  end
end

