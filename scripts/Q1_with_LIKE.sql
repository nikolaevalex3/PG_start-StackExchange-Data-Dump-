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
LIMIT 30;



EXPLAIN (ANALYZE, buffers)
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
LIMIT 30;