# frozen_string_literal: true

class PgTableDef < Redshift
  self.table_name = 'pg_table_def'

  def self.find_columns(schema, tablename)
    sql = <<"EOS"
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
  schemaname = '#{schema}'
  AND tablename = '#{tablename}'
EOS
    find_by_sql(sql)
  end
end
