# frozen_string_literal: true

class SvvTableInfo < Redshift
  self.table_name = 'svv_table_info'

  def self.find_stats_off
    sql = <<'EOS'
SELECT
  database,
  "schema",
  "table",
  stats_off
FROM
  svv_table_info
WHERE
  stats_off > 5
ORDER BY
  stats_off DESC
EOS
    find_by_sql(sql)
  end
end
