class PgUser < Redshift
  self.table_name = 'pg_user'

  def self.find_with_summary
    sql = <<'EOS'
SELECT
  userid::INTEGER,
  usename::VARCHAR,
  COUNT(*) AS count_query,
  MIN(starttime) AS started_at,
  MAX(starttime) AS last_at
FROM
  pg_user
  LEFT JOIN stl_query ON
    pg_user.usesysid = stl_query.userid
GROUP BY
  userid,
  usename
EOS
    find_by_sql(sql)
  end
end
