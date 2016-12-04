WITH queries AS (
  SELECT
    userid,
    query,
    pid,
    xid,
    starttime,
    endtime,
    elapsed / (1000 * 1000) AS elapsed_sec,
    "substring" AS sql_text
  FROM
    svl_qlog
  WHERE
    starttime >= (GETDATE() - INTERVAL '12 hour')
    AND elapsed >= 1000 * 1000 * 60 * 5
)

SELECT
  usename AS user_name,
  queries.*
FROM
  queries
  INNER JOIN pg_user
    ON queries.userid = pg_user.usesysid
ORDER BY
  queries.starttime
LIMIT 100
