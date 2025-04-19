BEGIN;

--PK
ALTER TABLE stackexchange_data.users ADD CONSTRAINT PK_users PRIMARY KEY (id);
ALTER TABLE stackexchange_data.badges ADD CONSTRAINT PK_badges PRIMARY KEY (id);
ALTER TABLE stackexchange_data.posts ADD CONSTRAINT PK_posts PRIMARY KEY (id);
ALTER TABLE stackexchange_data.postlinks ADD CONSTRAINT PK_postlinks PRIMARY KEY (id);
ALTER TABLE stackexchange_data.posthistory ADD CONSTRAINT PK_posthistory PRIMARY KEY (id);
ALTER TABLE stackexchange_data."comments" ADD CONSTRAINT PK_comments PRIMARY KEY (id);
ALTER TABLE stackexchange_data.tags ADD CONSTRAINT PK_tags PRIMARY KEY (id);
ALTER TABLE stackexchange_data.votes ADD CONSTRAINT PK_votes PRIMARY KEY (id);


--FK
ALTER TABLE stackexchange_data.badges
	ADD CONSTRAINT FK_badges_userid_users FOREIGN KEY (UserId)
	REFERENCES stackexchange_data.users(id);


ALTER TABLE stackexchange_data.posts 
    ADD CONSTRAINT FK_posts_OwnerUserId_users FOREIGN KEY (OwnerUserId)
    REFERENCES stackexchange_data.users(id),
    
    ADD CONSTRAINT FK_posts_LastEditorUserId_users FOREIGN KEY (LastEditorUserId)
    REFERENCES stackexchange_data.users(id),
    
    ADD CONSTRAINT FK_posts_AcceptedAnswerId_posts FOREIGN KEY (AcceptedAnswerId)
    REFERENCES stackexchange_data.posts(Id),
   
    ADD CONSTRAINT FK_posts_ParentId_posts FOREIGN KEY (ParentId)
    REFERENCES stackexchange_data.posts(id);

   
ALTER TABLE stackexchange_data.PostLinks 
    ADD CONSTRAINT FK_PostLinks_PostId_posts FOREIGN KEY (PostId)
    REFERENCES stackexchange_data.posts(id),
   
    ADD CONSTRAINT FK_PostLinks_RelatedPostId_posts FOREIGN KEY (RelatedPostId)
    REFERENCES stackexchange_data.posts(id);

      
ALTER TABLE stackexchange_data.PostHistory 
    ADD CONSTRAINT FK_PostHistory_PostId_posts FOREIGN KEY (PostId)
    REFERENCES stackexchange_data.posts(id),
   
    ADD CONSTRAINT FK_PostHistory_UserId_users FOREIGN KEY (UserId)
    REFERENCES stackexchange_data.users(id);   
   

ALTER TABLE stackexchange_data."comments" 
    ADD CONSTRAINT FK_comments_PostId_posts FOREIGN KEY (PostId)
    REFERENCES stackexchange_data.posts(id),
   
    ADD CONSTRAINT FK_comments_UserId_users FOREIGN KEY (UserId)
    REFERENCES stackexchange_data.users(id);
   
   
ALTER TABLE stackexchange_data.Tags 
    ADD CONSTRAINT FK_tags_ExcerptPostId_post FOREIGN KEY (ExcerptPostId)
    REFERENCES stackexchange_data.posts(id),
   
    ADD CONSTRAINT FK_tags_WikiPostId_post FOREIGN KEY (WikiPostId)
    REFERENCES stackexchange_data.posts(id);


ALTER TABLE stackexchange_data.Votes 
    ADD CONSTRAINT FK_votes_PostId_posts FOREIGN KEY (PostId)
    REFERENCES stackexchange_data.posts(id),
   
    ADD CONSTRAINT FK_votes_UserId_users FOREIGN KEY (UserId)
    REFERENCES stackexchange_data.users(id);

COMMIT;