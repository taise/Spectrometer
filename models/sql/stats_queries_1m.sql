SELECT
  TO_CHAR(starttime, 'YYYY-MM-DD HH24:MI:00')::TIMESTAMP AS started_at,
  COUNT(DISTINCT userid) AS uu_count,
  COUNT(DISTINCT query) AS query_count
FROM
  stl_query
WHERE
  starttime BETWEEN
    GETDATE() - INTERVAL '3 hours'
    AND GETDATE() - INTERVAL '1 minute'
GROUP BY
  started_at
ORDER BY
  started_at
