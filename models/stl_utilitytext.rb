# ref: https://github.com/awslabs/amazon-redshift-utils/blob/master/src/AdminViews/v_get_cluster_restart_ts.sql
class  StlUtilitytext < Redshift
  self.table_name = 'stl_utilitytext'

  def self.find_cluster_restart
  sql = <<'EOS'
SELECT
  sysdate AS current_ts,
  endtime AS restart_ts
FROM
  stl_utilitytext
WHERE
  text LIKE '%xen_is_up.sql%'
  AND userid = 1
ORDER BY
  endtime DESC
EOS
    find_by_sql(sql)
  end
end
