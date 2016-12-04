SELECT
  database,
  "schema",
  "table",
  stats_off
FROM
  svv_table_info
WHERE
  stats_off > 5
ORDER BY
  stats_off DESC
