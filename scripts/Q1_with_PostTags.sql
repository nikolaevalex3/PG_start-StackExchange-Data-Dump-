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
LIMIT 30;



EXPLAIN (ANALYZE, buffers)
SELECT 
t1.tagname AS first_tag,
t2.tagname AS second_tag,
avg(a.creationdate - q.creationdate) AS answer_time,
round(avg(u.reputation)),
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
LIMIT 30;

	 
	 
	 
	 
	 
	 