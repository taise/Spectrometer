SELECT
  se.userid,
  TRIM(usename) AS username,
  process,
  recordtime,
  errcode,
  TRIM(error) AS error_message
FROM
  pg_catalog.stl_error AS se
  LEFT JOIN pg_user
    ON se.userid = pg_user.usesysid
WHERE
  recordtime >= GETDATE() - INTERVAL '3 hour'
  -- ignore unrecognized configuration parameter "application_name"
  AND errcode != 17
ORDER BY
  recordtime DESC
LIMIT 30
