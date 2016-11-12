# frozen_string_literal: true

class StvTblPerm < Redshift
  self.table_name = 'stv_tbl_perm'

  def self.find_tables
    sql = <<'EOS'
WITH tables AS (
  SELECT
    db_id,
    id,
    name,
    SUM(rows) AS rows
  FROM
   stv_tbl_perm AS stp
  GROUP BY
    db_id,
    id,
    name
),

table_sizes AS (
  SELECT
    tbl AS table_id,
    COUNT(*) AS mbytes
  FROM
    stv_blocklist
  GROUP BY
    table_id
)

SELECT
  TRIM(pgdb.datname) AS database_name,
  pgn.oid AS schema_id,
  TRIM(pgn.nspname) AS schema_name,
  pgc.oid AS table_id,
  TRIM(tables.name) AS tablename,
  table_sizes.mbytes,
  tables.rows,
  CAST(pu.usename AS VARCHAR(50)) AS owner
FROM
  tables
  LEFT JOIN pg_class AS pgc
    ON pgc.oid = tables.id
  LEFT JOIN pg_user AS pu
    ON (pgc.relowner = pu.usesysid)
  LEFT JOIN pg_namespace AS pgn
    ON pgn.oid = pgc.relnamespace
    AND pgn.nspowner > 1
  LEFT JOIN pg_database AS pgdb
    ON pgdb.oid = tables.db_id
  LEFT JOIN table_sizes
    ON tables.id = table_sizes.table_id
ORDER BY
  tables.db_id,
  schema_id,
  tablename
EOS
    find_by_sql(sql)
  end
end
