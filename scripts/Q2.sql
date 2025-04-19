SELECT q.id AS question_id, a.id AS answer_id, a.score, u.displayname AS username
FROM stackexchange_data.posts AS q
JOIN stackexchange_data.PostTags pt ON pt.postid = q.id
JOIN stackexchange_data.posts AS a ON q.acceptedanswerid = a.id
LEFT JOIN stackexchange_data.users AS u ON a.owneruserid = u.id
WHERE pt.tagid = 10 AND a.score < 0
ORDER BY a.score
LIMIT 30;


EXPLAIN (ANALYZE, BUFFERS)
SELECT q.id AS question_id, a.id AS answer_id, a.score, u.displayname AS username
FROM stackexchange_data.posts AS q
JOIN stackexchange_data.PostTags pt ON pt.postid = q.id
JOIN stackexchange_data.posts AS a ON q.acceptedanswerid = a.id
LEFT JOIN stackexchange_data.users AS u ON a.owneruserid = u.id
WHERE pt.tagid = 10 AND a.score < 0
ORDER BY a.score
LIMIT 30;
