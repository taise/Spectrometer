WITH wlm_queries AS (
  SELECT
    service_class,
    userid,
    "query" AS query_id,
    final_state AS state,
    total_exec_time / 1000000 AS total_exec_time_sec,
    total_queue_time / 1000000 AS total_queue_time_sec,
    queue_start_time,
    queue_end_time,
    exec_start_time,
    exec_end_time
  FROM
    STL_WLM_QUERY
  WHERE
    exec_start_time >= GETDATE() - INTERVAL '3 hours'
    AND total_exec_time > 60000000 -- 60 sec
  ORDER BY
    (total_exec_time + total_queue_time) DESC
  LIMIT 100
),

inflight_queries AS (
  SELECT
    99,  -- service_class
    si.userid,
    si."query" AS query_id,
    qs.state AS state,
    qs.exec_time / 1000000 AS total_exec_time_sec,
    qs.queue_time / 1000000 AS total_queue_time_sec,
    qs.wlm_start_time AS queue_start_time,
    NULL AS queue_end_time,
    si.starttime AS exec_start_time,
    NULL AS exec_end_time
  FROM
    stv_inflight AS si
    INNER JOIN stv_wlm_query_state AS qs
      ON si.query = qs.query
  WHERE
    qs.exec_time > 60000000 -- 60 sec
),

queries AS (
  SELECT * FROM wlm_queries
  UNION
  SELECT * FROM inflight_queries
)

SELECT
  service_class,
  TRIM(usename) AS user_name,
  query_id,
  TRIM(state) AS state,
  total_exec_time_sec,
  total_queue_time_sec,
  queue_start_time,
  queue_end_time,
  exec_start_time,
  exec_end_time
FROM
  queries
  INNER JOIN pg_user AS pu
    ON queries.userid = pu.usesysid
ORDER BY
  service_class,
  queue_start_time
