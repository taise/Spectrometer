class PgUser < Redshift
  self.table_name = 'pg_user'

  def self.find_with_summary
    sql = <<'EOS'
WITH queries AS (
  SELECT
    userid,
    COUNT(*) AS count_query,
    MIN(starttime) AS started_at,
    MAX(starttime) AS last_at
  FROM
    stl_query
  GROUP BY
    userid
)

SELECT
  usesysid::INTEGER AS id,
  TRIM(usename) AS name,
  count_query,
  started_at,
  last_at
FROM
  pg_user
  LEFT JOIN queries ON
    pg_user.usesysid = queries.userid
ORDER BY id
EOS
    find_by_sql(sql)
  end
end
