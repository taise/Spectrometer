SELECT
  "column",
  "type" AS column_type,
  "encoding",
  "distkey",
  "sortkey",
  "notnull"
FROM
  pg_table_def
WHERE
  schemaname = '__schema__'
  AND tablename = '__tablename__'
