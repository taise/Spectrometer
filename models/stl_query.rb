# frozen_string_literal: true

class StlQuery < Redshift
  self.table_name = 'stl_query'

  # TODO: using ActiveRecord::QueryMethods
  def self.queries_per_minute
    sql = <<'EOS'
SELECT
  TO_CHAR(starttime, 'YYYY-MM-DD HH24:MI:00')::TIMESTAMP AS started_at,
  COUNT(DISTINCT userid) AS uu_count,
  COUNT(DISTINCT query) AS query_count
FROM
  stl_query
WHERE
  starttime BETWEEN
    GETDATE() - INTERVAL '3 hours'
    AND GETDATE() - INTERVAL '1 minute'
GROUP BY
  started_at
ORDER BY
  started_at
EOS
    find_by_sql(sql)
  end

  def self.queries_per_10_minutes
    sql = <<'EOS'
SELECT
  (LEFT(TO_CHAR(starttime, 'YYYY-MM-DD HH24:MI'), 15) || '0:00')::TIMESTAMP AS started_at,
  COUNT(DISTINCT userid) AS uu_count,
  COUNT(DISTINCT query) AS query_count
FROM
  stl_query
WHERE
  starttime BETWEEN
    GETDATE() - INTERVAL '1 day'
    AND GETDATE() - INTERVAL '1 minute'
GROUP BY
  started_at
ORDER BY
  started_at
EOS
    find_by_sql(sql)
  end
end
