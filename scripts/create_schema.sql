CREATE SCHEMA stackexchange_data;

CREATE TABLE stackexchange_data.users (
    Id INT,
    Reputation INT NOT NULL,
    CreationDate TIMESTAMP NOT NULL,
    DisplayName VARCHAR,
    LastAccessDate TIMESTAMP,
    WebsiteUrl VARCHAR,
    Location VARCHAR,
    AboutMe VARCHAR,
    Views INT NOT NULL,
    UpVotes INT NOT NULL,
    DownVotes INT NOT NULL,
    AccountId INT
);

CREATE TABLE stackexchange_data.badges (
    Id INT,
    UserId INT,
    Name VARCHAR,
    Date TIMESTAMP,
    Class SMALLINT, 
    TagBased BOOLEAN    
);


CREATE TABLE stackexchange_data.posts (
    Id INT,   
    PostTypeId SMALLINT NOT NULL,  
    AcceptedAnswerId INT, 
    ParentId INT,
    CreationDate TIMESTAMP NOT NULL,
    Score INT NOT NULL,
    ViewCount INT,
    Body VARCHAR,
    OwnerUserId INT,    
    OwnerDisplayName VARCHAR,
    LastEditorUserId INT,  
    LastEditorDisplayName VARCHAR,
    LastEditDate TIMESTAMP,
    LastActivityDate TIMESTAMP,
    Title VARCHAR,
    Tags VARCHAR,
    AnswerCount INT,
    CommentCount INT,
    FavoriteCount INT,
    ClosedDate TIMESTAMP,
    CommunityOwnedDate TIMESTAMP,
	ContentLicense VARCHAR
);

CREATE TABLE stackexchange_data.postlinks (
    Id INT,
    CreationDate TIMESTAMP NOT NULL,
    PostId INT NOT NULL, 
    RelatedPostId INT NOT NULL, 
    LinkTypeId SMALLINT NOT NULL
);

CREATE TABLE stackexchange_data.posthistory (
    Id INT, 
    PostHistoryTypeId SMALLINT NOT NULL, 
    PostId INT NOT NULL, 
    RevisionGUID UUID NOT NULL,
    CreationDate TIMESTAMP NOT NULL,
    UserId INTEGER,  
    UserDisplayName VARCHAR,
    Comment VARCHAR,
    Text VARCHAR,
    ContentLicense VARCHAR
);

CREATE TABLE stackexchange_data.comments (
    Id INT,
    PostId INT NOT NULL, 
    Score INT NOT NULL,
    Text VARCHAR NOT NULL,  
    CreationDate TIMESTAMP NOT NULL,
    UserDisplayName VARCHAR,
    UserId INT
);

CREATE TABLE stackexchange_data.tags (
    Id INT,
    TagName VARCHAR,
    Count INT NOT NULL,
    ExcerptPostId INT,
    WikiPostId INT,
    IsRequired BOOLEAN,
    IsModeratorOnly BOOLEAN
);

CREATE TABLE stackexchange_data.votes (
    Id INT,
    PostId INT NOT NULL,  
    VoteTypeId SMALLINT NOT NULL,
    UserId INT, 
    CreationDate TIMESTAMP,
    BountyAmount INT
);