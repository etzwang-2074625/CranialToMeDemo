class QueryBuilder
  FIELD_WHITELIST = {
    "patient_tasks" => {
      "task_name"  => [:contains, :not_contains, :all],
      "task_count" => [:equals, :gte, :lte, :all],
    },
    "demographics" => {
      "age"        => [:equals, :gte, :lte, :all],
      "sex"        => [:contains, :not_contains, :all],
      "dob"        => [:before, :after, :all],
      "aoo"        => [:equals, :gte, :lte, :all],
      "ehi"        => [:contains, :not_contains, :all],
      "ld"         => [:contains, :not_contains, :all],
      "wada"       => [:contains, :not_contains, :all],
      "fmriSide"   => [:contains, :not_contains, :all],
      "csm"        => [:contains, :not_contains, :all],
      "surgHemi"   => [:contains, :not_contains, :all],
      "surgType"   => [:contains, :not_contains, :all],
      "surgDesc"   => [:contains, :not_contains, :all],
      "dos"        => [:before, :after, :all],
      "ilae"       => [:contains, :not_contains, :all],
      "engle"      => [:contains, :not_contains, :all],
      "etiology"   => [:contains, :not_contains, :all],
      "mri"        => [:contains, :not_contains, :all]
    },
    "epilepsies" => {
      "phase2"                  => [:contains, :not_contains, :all],
      "phase2implant"           => [:before, :after, :all],
      "phase2explant"           => [:before, :after, :all],
      "phase2duration"          => [:contains, :not_contains, :all],
      "phase2complication"      => [:contains, :not_contains, :all],
      "side"                    => [:contains, :not_contains, :all],
      "resection"               => [:contains, :not_contains, :all],
      "surgery_type"            => [:contains, :not_contains, :all],
      "adult"                   => [:contains, :not_contains, :all],
      "rxn_date"                => [:before, :after, :all],
      "additional_intervention" => [:contains, :not_contains, :all],
      "notes"                   => [:all]
    },
    "cceps" => {
      "date"           => [:before, :after, :all],
      "csm_notes"      => [:all],
      "hemisphere"     => [:contains, :not_contains, :all],
      "seeg_or_sde"    => [:contains, :not_contains, :all],
      "anode"          => [:contains, :not_contains, :all],
      "cathode"       => [:contains, :not_contains, :all],
      "data_available" => [:all],
      "sector_1_file_name" => [:contains, :not_contains, :all],
      'time' => [:equals, :gte, :lte, :all],
      "ccep_amplitude" => [:contains, :not_contains, :all],
      "notes"      => [:all],
      "anode_location"     => [:contains, :not_contains, :all],
      "cathode_location"     => [:contains, :not_contains, :all],
      "anode_surf_location"     => [:contains, :not_contains, :all],
      "cathode_surf_location"     => [:contains, :not_contains, :all]

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

