# frozen_string_literal: true

class StlLoadError < Redshift
  def self.find_with_table_info
    sql = <<-"EOS"
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
  userid,
  schema_name AS schema,
  table_name,
  starttime,
  line_number,
  colname,
  "type" AS column_type,
  col_length,
  position,
  raw_field_value,
  err_reason
FROM
  stl_load_errors AS sle
  LEFT JOIN tables
    ON sle.tbl = tables.table_id
ORDER BY
  starttime DESC
EOS
    find_by_sql(sql)
  end
end
