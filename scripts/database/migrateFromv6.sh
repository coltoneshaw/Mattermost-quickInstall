
## MySQL

INSERT INTO Systems (Name,Value) VALUES ('Version','5.38.0') ON DUPLICATE KEY UPDATE Value = '5.38.0';

CREATE INDEX idx_status_status ON Status (Status);
DROP INDEX idx_status_status_dndendtime ON Status;
CREATE INDEX idx_channelmembers_user_id ON ChannelMembers (UserId);
DROP INDEX idx_channelmembers_channel_id_scheme_guest_user_id ON ChannelMembers;
DROP INDEX idx_channelmembers_user_id_channel_id_last_viewed_at ON ChannelMembers;
CREATE INDEX idx_threads_channel_id ON Threads (ChannelId);
DROP INDEX idx_threads_channel_id_last_reply_at ON Threads;
CREATE INDEX idx_channels_team_id ON Channels (TeamId);
DROP INDEX idx_channels_team_id_type ON Channels;
DROP INDEX idx_channels_team_id_display_name ON Channels;
CREATE INDEX idx_posts_root_id ON Posts (RootId);
DROP INDEX idx_posts_root_id_delete_at ON Posts;

ALTER TABLE CommandWebhooks ADD COLUMN ParentId varchar(26);
UPDATE CommandWebhooks SET ParentId = '';
ALTER TABLE Posts ADD COLUMN ParentId varchar(26);
UPDATE Posts SET ParentId = '';

ALTER TABLE Users MODIFY Timezone text;
ALTER TABLE Users MODIFY NotifyProps text;
ALTER TABLE Users MODIFY Props text;
ALTER TABLE Threads MODIFY Participants longtext;
ALTER TABLE Sessions MODIFY Props text;
ALTER TABLE Posts MODIFY Props text;
ALTER TABLE Jobs MODIFY Data text;
ALTER TABLE LinkMetadata MODIFY Data text;
ALTER TABLE ChannelMembers MODIFY NotifyProps text;



## Postgres

INSERT INTO Systems (Name,Value) VALUES ('Version','5.38.0') ON CONFLICT (name) DO UPDATE SET Value = '5.38.0';

CREATE INDEX idx_status_status ON Status (Status);
DROP INDEX idx_status_status_dndendtime;
CREATE INDEX idx_channelmembers_user_id ON ChannelMembers (UserId);
DROP INDEX idx_channelmembers_user_id_channel_id_last_viewed_at;
DROP INDEX idx_channelmembers_channel_id_scheme_guest_user_id;
CREATE INDEX idx_threads_channel_id ON Threads (ChannelId);
DROP INDEX idx_threads_channel_id_last_reply_at;
CREATE INDEX idx_channels_team_id ON Channels (TeamId);
DROP INDEX idx_channels_team_id_type;
DROP INDEX idx_channels_team_id_display_name;
CREATE INDEX idx_posts_root_id ON Posts (RootId);
DROP INDEX idx_posts_root_id_delete_at;

ALTER TABLE CommandWebhooks ADD COLUMN ParentId varchar(26);
UPDATE CommandWebhooks SET ParentId = '';
ALTER TABLE Posts ADD COLUMN ParentId varchar(26);
UPDATE Posts SET ParentId = '';

ALTER TABLE users ALTER COLUMN timezone TYPE varchar(256);
ALTER TABLE users ALTER COLUMN notifyprops TYPE varchar(2000);
ALTER TABLE users ALTER COLUMN props TYPE varchar(4000);
ALTER TABLE threads ALTER COLUMN participants TYPE text;
ALTER TABLE sessions ALTER COLUMN props TYPE varchar(1000);
ALTER TABLE posts ALTER COLUMN props TYPE varchar(8000);
ALTER TABLE linkmetadata ALTER COLUMN data TYPE varchar(4096);
ALTER TABLE jobs ALTER COLUMN data TYPE varchar(1024);
ALTER TABLE channelmembers ALTER COLUMN notifyprops TYPE varchar(2000);