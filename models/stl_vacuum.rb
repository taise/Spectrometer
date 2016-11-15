# frozen_string_literal: true

class StlVacuum < Redshift
  self.table_name = 'stl_vacuum'

  def self.find_results
    sql = <<'EOS'
WITH tables AS (
  SELECT
    DISTINCT TRIM(pgn.nspname) AS schema_name,
    name AS table_name,
    stp.id AS table_id
  FROM
    stv_tbl_perm AS stp
    INNER JOIN pg_class pgc ON pgc.oid = stp.id
    INNER JOIN pg_namespace pgn ON pgn.oid = pgc.relnamespace
)

SELECT
  vac_start.userid,
  vac_start.table_id,
  tables.schema_name,
  tables.table_name,
  vac_start.eventtime AS start_time,
  vac_end.eventtime AS end_time,
  vac_start.rows AS start_rows,
  vac_end.rows AS end_rows,
  vac_start.blocks AS start_blocks,
  vac_end.blocks AS end_blocks,
  (vac_start.rows - vac_end.rows) AS rows_deleted,
  (vac_start.blocks - vac_end.blocks) AS blocks_deleted_added,
  DATEDIFF(seconds, vac_start.eventtime, vac_end.eventtime) AS processing_seconds
FROM
  stl_vacuum AS vac_start
  LEFT JOIN stl_vacuum AS vac_end
    ON vac_start.userid = vac_end.userid
      AND vac_start.table_id = vac_end.table_id
      AND vac_start.xid = vac_end.xid
      AND vac_start.status = 'Started'
      AND vac_end.status = 'Finished'
  INNER JOIN tables
    ON tables.table_id = vac_start.table_id
WHERE
  start_time >= CURRENT_TIME - INTERVAL '1 week'
ORDER BY
  start_time DESC
EOS
    find_by_sql(sql)
  end
end
