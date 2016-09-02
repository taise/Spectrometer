# frozen_string_literal: true

class SvlQlog < Redshift
  self.table_name = 'svl_qlog'
  WITHIN = 12  # hours
  OVER = 5     # minutes

  # TODO: using ActiveRecord::QueryMethods
  def self.find_slow_queries
    sql = <<"EOS"
WITH queries AS (
  SELECT
    userid,
    query,
    pid,
    xid,
    starttime,
    endtime,
    elapsed / (1000 * 1000) AS elapsed_sec,
    "substring" AS sql_text
  FROM
    svl_qlog
  WHERE
    starttime >= (GETDATE() - INTERVAL '#{WITHIN} hour')
    AND elapsed >= 1000 * 1000 * 60 * #{OVER}
)

SELECT
  usename AS user_name,
  queries.*
FROM
  queries
  INNER JOIN pg_user
    ON queries.userid = pg_user.usesysid
ORDER BY
  queries.starttime
LIMIT 100
;
EOS
    find_by_sql(sql)
  end

  def elapsed_time
    min = self.elapsed_sec.to_i / 60
    sec = self.elapsed_sec.to_i % 60
    "#{min}:#{'%02d' % sec}"
  end
end
