SELECT
  sysdate AS current_ts,
  endtime AS restart_ts
FROM
  stl_utilitytext
WHERE
  text LIKE '%xen_is_up.sql%'
  AND userid = 1
ORDER BY
  endtime DESC
