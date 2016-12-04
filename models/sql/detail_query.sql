WITH queries AS (
  SELECT
    userid,
    xid,
    pid,
    starttime,
    endtime,
    DATEDIFF(sec, starttime, endtime) AS elapsed_time,
    "sequence",
    "type" AS query_type,
    TRIM(text) AS text
  FROM
    svl_statementtext
  WHERE
    xid = __xid__
)

SELECT
  TRIM(usename) AS user_name,
  queries.*
FROM
  queries
  INNER JOIN pg_user
    ON queries.userid = pg_user.usesysid
ORDER BY
  starttime,
  "sequence"
