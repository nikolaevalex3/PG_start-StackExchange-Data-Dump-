CREATE TABLE stackexchange_data.PostTags (
    PostId INT NOT NULL,
    TagId INT NOT NULL
);


WITH post_tag_pairs AS (
    SELECT
        p.id AS post_id,
        unnest(string_to_array(trim(both '|' from p.tags), '|')) AS tag_name
    FROM stackexchange_data.posts p
    WHERE p.tags IS NOT NULL
),
tag_ids AS (
    SELECT ptp.post_id, t.id AS tag_id
    FROM post_tag_pairs ptp
    JOIN stackexchange_data.tags t ON t.TagName = ptp.tag_name
)
INSERT INTO stackexchange_data.PostTags (PostId, TagId)
SELECT post_id, tag_id
FROM tag_ids
ON CONFLICT DO NOTHING;

ALTER TABLE stackexchange_data.PostTags
ADD CONSTRAINT Fk_PostTags_Posts FOREIGN KEY (PostId)
    REFERENCES stackexchange_data.Posts (Id);

ALTER TABLE stackexchange_data.PostTags
ADD CONSTRAINT Fk_PostTags_Tags FOREIGN KEY (TagId)
    REFERENCES stackexchange_data.Tags (Id);


-- Индексы для таблицы PostTags
CREATE INDEX IF NOT EXISTS idx_posttags_postid_tagid ON stackexchange_data.PostTags (PostId, TagId);
CREATE INDEX IF NOT EXISTS idx_posttags_tagid ON stackexchange_data.posttags(tagid);

-- Индексы для таблицы badges
CREATE INDEX IF NOT EXISTS idx_badges_userid ON stackexchange_data.badges (UserId);

-- Индексы для таблицы posts
CREATE INDEX IF NOT EXISTS idx_posts_lasteditoruserid ON stackexchange_data.posts (LastEditorUserId)
WHERE LastEditorUserId IS NOT NULL;

CREATE INDEX IF NOT EXISTS idx_posts_acceptedanswerid ON stackexchange_data.posts (AcceptedAnswerId)
WHERE AcceptedAnswerId IS NOT NULL;

CREATE INDEX IF NOT EXISTS idx_posts_parentid ON stackexchange_data.posts (ParentId)
WHERE ParentId IS NOT NULL;

CREATE INDEX IF NOT EXISTS idx_posts_owneruserid ON stackexchange_data.posts (owneruserid);

CREATE INDEX IF NOT EXISTS idx_posts_score ON stackexchange_data.posts(score);

CREATE EXTENSION IF NOT EXISTS pg_trgm;
CREATE INDEX IF NOT EXISTS tags_trgm_idx ON stackexchange_data.posts
USING GIN (tags gin_trgm_ops);

-- Индексы для таблицы PostLinks
CREATE INDEX IF NOT EXISTS idx_postlinks_postid ON stackexchange_data.PostLinks (PostId);
CREATE INDEX IF NOT EXISTS idx_postlinks_relatedpostid ON stackexchange_data.PostLinks (RelatedPostId);

-- Индексы для таблицы PostHistory
CREATE INDEX IF NOT EXISTS idx_posthistory_postid ON stackexchange_data.PostHistory (PostId);
CREATE INDEX IF NOT EXISTS idx_posthistory_userid ON stackexchange_data.PostHistory (UserId);

-- Индексы для таблицы comments
CREATE INDEX IF NOT EXISTS idx_comments_postid ON stackexchange_data."comments" (PostId);
CREATE INDEX IF NOT EXISTS idx_comments_userid ON stackexchange_data."comments" (UserId);

-- Индексы для таблицы Tags
CREATE INDEX IF NOT EXISTS idx_tags_excerptpostid ON stackexchange_data.Tags (ExcerptPostId);
CREATE INDEX IF NOT EXISTS idx_tags_wikipostid ON stackexchange_data.Tags (WikiPostId);

-- Индексы для таблицы Votes
CREATE INDEX IF NOT EXISTS idx_votes_postid ON stackexchange_data.Votes (PostId);
CREATE INDEX IF NOT EXISTS idx_votes_userid ON stackexchange_data.Votes (UserId)
WHERE (UserId)IS NOT NULL;
