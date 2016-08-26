# frozen_string_literal: true

class StvInflight < Redshift
  self.table_name = 'stv_inflight'

  # TODO: using ActiveRecord::QueryMethods
  def self.find_running_queries
    sql = <<'EOS'
SELECT
  si.pid,
  u.usename AS user,
  qs.exec_time / 1000000 AS exec_time,
  qs.queue_time / 1000000 AS queue_time,
  si.starttime,
  si.text
FROM
  stv_inflight AS si
  LEFT JOIN stv_wlm_query_state AS qs
    ON si.query = qs.query
  LEFT JOIN pg_user AS u
    ON u.usesysid = si.userid
WHERE
  qs.state = 'Running'
ORDER BY
  starttime
EOS
    find_by_sql(sql)
  end

  # stv_inflight.slice is defined by Active Record.
  def self.instance_method_already_implemented?(method_name)
    super(method_name)
  rescue ActiveRecord::DangerousAttributeError
    true
  end
end
