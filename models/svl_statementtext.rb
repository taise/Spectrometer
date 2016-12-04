# frozen_string_literal: true

class SvlStatementtext < Redshift
  self.table_name = 'svl_statementtext'

  # TODO: using ActiveRecord::QueryMethods
  def self.find_query_full_text(xid)
    sql = <<"EOS"
WITH queries AS (
  SELECT
    userid,
    xid,
    pid,
    starttime,
    endtime,
    "sequence",
    "type" AS query_type,
    text
  FROM
    svl_statementtext
  WHERE
    xid = #{xid}
)

SELECT
  usename AS user_name,
  queries.*
FROM
  queries
  INNER JOIN pg_user
    ON queries.userid = pg_user.usesysid
ORDER BY
  starttime,
  "sequence"
;
EOS
    find_by_sql(sql)
  end

  def elapsed_time
    elapsed_sec = (self.endtime - self.starttime).to_i
    min = elapsed_sec / 60
    sec = elapsed_sec % 60
    "#{min}:#{'%02d' % sec}"
  end
end
