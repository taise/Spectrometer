SELECT
  ti.database AS db,
  ti.SCHEMA AS schema,
  ti.table_id,
  ti."table" AS tablename,
  ti.max_varchar,
  CASE
    WHEN ti.diststyle NOT IN ('EVEN','ALL') THEN ti.diststyle || ': ' || ti.skew_rows
    ELSE ti.diststyle
  END AS diststyle,
  CASE
    WHEN ti.sortkey1 IS NOT NULL AND ti.sortkey1_enc IS NOT NULL THEN ti.sortkey1 || '(' || NVL(skew_sortkey1, 0) || ')'
    WHEN ti.sortkey1 IS NOT NULL THEN ti.sortkey1
    ELSE NULL
  END AS sort_key,
  ti.tbl_rows AS rows,
  ti.unsorted,
  ti.stats_off
FROM
  svv_table_info AS ti
WHERE
  ti.table_id = __table_id__  -- replace
  AND ti.SCHEMA NOT IN ('pg_internal')
ORDER BY
  ti.pct_used DESC
