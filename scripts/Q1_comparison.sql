DO $$
DECLARE
  t_start TIMESTAMP;
  t_end TIMESTAMP;
  elapsed INTERVAL;
  total INTERVAL := INTERVAL '0'; 
  avg_ms DOUBLE PRECISION;
BEGIN
  RAISE NOTICE 'Запрос через PostTags';
  FOR i IN 1..30 LOOP
    t_start := clock_timestamp();

    PERFORM 1 FROM (
    SELECT 
    t1.tagname AS first_tag,
    t2.tagname AS second_tag,
    date_trunc('second',avg(a.creationdate - q.creationdate)) AS avg_answer_time,
    round(avg(u.reputation)) AS avg_reputation,
    count(DISTINCT q.id) AS count_q
    FROM stackexchange_data.posts q
    JOIN stackexchange_data.posttags pt1 ON q.id = pt1.postid 
    JOIN stackexchange_data.posttags pt2 ON q.id = pt2.postid 
    LEFT JOIN stackexchange_data.posts a ON q.id = a.parentid
    LEFT JOIN stackexchange_data.users u ON a.owneruserid = u.id
    JOIN stackexchange_data.tags t1 ON t1.id = pt1.tagid
    JOIN stackexchange_data.tags t2 ON t2.id = pt2.tagid
    WHERE pt1.tagid < pt2.tagid  
    	AND pt1.tagid <> 10
        AND pt2.tagid <> 10
        AND q.posttypeid = 1
        AND EXISTS (
        	SELECT 1
          	FROM stackexchange_data.posttags pt
          	WHERE pt.postid = q.id
            AND pt.tagid = 10  -- postgresql
        	)
    GROUP BY first_tag, second_tag
    ORDER BY count_q DESC
    LIMIT 30
    ) AS sub;

    t_end := clock_timestamp();
    elapsed := t_end - t_start;
    total := total + elapsed;

    RAISE NOTICE 'Run %, time: % ms', i, EXTRACT(MILLISECOND FROM elapsed);
  END LOOP;

  avg_ms := EXTRACT(EPOCH FROM total) * 1000 / 30;
  RAISE NOTICE 'Average execution time over 30 runs: %.2f ms', avg_ms;
END$$;



DO $$
DECLARE
  t_start TIMESTAMP;
  t_end TIMESTAMP;
  elapsed INTERVAL;
  total INTERVAL := INTERVAL '0'; 
  avg_ms DOUBLE PRECISION;
BEGIN
  RAISE NOTICE 'Запрос с поиском по LIKE';
  FOR i IN 1..30 LOOP
    t_start := clock_timestamp();

    PERFORM 1 FROM (
    SELECT 
	t1.tag AS first_tag,
	t2.tag AS second_tag,
	avg(a.creationdate - p.creationdate) AS answer_time,
	avg(u.reputation),
	count(DISTINCT p.id) AS count_q
	FROM stackexchange_data.posts p
	CROSS JOIN LATERAL unnest(string_to_array(trim(both '|' from p.tags), '|')) AS t1(tag)
	CROSS JOIN LATERAL unnest(string_to_array(trim(both '|' from p.tags), '|')) AS t2(tag)
	LEFT JOIN stackexchange_data.posts a ON p.id = a.parentid
	LEFT JOIN stackexchange_data.users u ON a.owneruserid = u.id
	WHERE p.tags LIKE '%|postgresql|%'
		AND p.posttypeid = 1
		AND t1.tag < t2.tag
		AND t1.tag <> 'postgresql'
		AND t2.tag <> 'postgresql'
	GROUP BY first_tag, second_tag
	ORDER BY count_q DESC
	LIMIT 30
    ) AS sub;

    t_end := clock_timestamp();
    elapsed := t_end - t_start;
    total := total + elapsed;

    RAISE NOTICE 'Run %, time: % ms', i, EXTRACT(MILLISECOND FROM elapsed);
  END LOOP;

  avg_ms := EXTRACT(EPOCH FROM total) * 1000 / 30;
  RAISE NOTICE 'Average execution time over 30 runs: %.2f ms', avg_ms;
END$$;