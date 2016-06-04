class StlError < Redshift
  self.table_name = 'stl_error'

  def self.find_join_user
    sql = <<'EOS'
WITH users AS (
  SELECT
    usesysid AS userid,
    TRIM(usename) AS username
  FROM
    pg_user
)

SELECT
  se.userid,
  username,
  recordtime,
  errcode,
  TRIM(context) AS context,
  TRIM(error) AS error_message
FROM
  pg_catalog.stl_error AS se
  LEFT JOIN users
    ON se.userid = users.userid
WHERE
  recordtime >= GETDATE() - INTERVAL '3 hour'
ORDER BY
  recordtime DESC
LIMIT 30
EOS
    find_by_sql(sql)
  end
end
