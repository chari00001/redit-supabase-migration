-- Users Table
CREATE TABLE Users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    role VARCHAR(20) NOT NULL DEFAULT 'user',
    profile_picture_url VARCHAR(255),
    bio TEXT,
    location VARCHAR(100),
    date_of_birth DATE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    is_verified BOOLEAN DEFAULT FALSE,
    last_login TIMESTAMP WITH TIME ZONE,
    notification_preferences JSONB,
    post_count INTEGER DEFAULT 0,
    account_status VARCHAR(20) DEFAULT 'active' CHECK (account_status IN ('active', 'suspended', 'deactivated')),
    subscription_level VARCHAR(10) DEFAULT 'free' CHECK (subscription_level IN ('free', 'premium', 'vip')),
    subscription_expiration DATE
);

-- Posts Table
CREATE TABLE Posts (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES Users(id),
    title VARCHAR(255) NOT NULL,
    content TEXT,
    media_url VARCHAR(255),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    likes_count INTEGER DEFAULT 0 NOT NULL,
    comments_count INTEGER DEFAULT 0 NOT NULL,
    shares_count INTEGER DEFAULT 0 NOT NULL,
    views_count INTEGER DEFAULT 0 NOT NULL,
    visibility VARCHAR(10) DEFAULT 'public' NOT NULL CHECK (visibility IN ('public', 'private', 'followers')),
    tags JSONB,
    allow_comments BOOLEAN DEFAULT TRUE,
    is_pinned BOOLEAN DEFAULT FALSE
);

-- Comments Table
CREATE TABLE Comments (
    id SERIAL PRIMARY KEY,
    post_id INTEGER NOT NULL REFERENCES Posts(id),
    user_id INTEGER NOT NULL REFERENCES Users(id),
    parent_id INTEGER REFERENCES Comments(id) DEFAULT NULL,
    content TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    likes_count INTEGER DEFAULT 0 NOT NULL,
    replies_count INTEGER DEFAULT 0 NOT NULL,
    is_pinned BOOLEAN DEFAULT FALSE,
    anonymous BOOLEAN DEFAULT FALSE
);

-- Communities Table
CREATE TABLE Communities (
    id SERIAL PRIMARY KEY,
    creator_id INTEGER NOT NULL REFERENCES Users(id),
    name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    visibility VARCHAR(10) DEFAULT 'public' NOT NULL CHECK (visibility IN ('public', 'private', 'restricted')),
    member_count INTEGER DEFAULT 0 NOT NULL,
    is_verified BOOLEAN DEFAULT FALSE,
    rules TEXT,
    post_count INTEGER DEFAULT 0 NOT NULL,
    tags JSONB,
    is_featured BOOLEAN DEFAULT FALSE,
    cover_image_url VARCHAR(255)
);

-- User_Communities Table
CREATE TABLE User_Communities (
    user_id INTEGER NOT NULL REFERENCES Users(id),
    community_id INTEGER NOT NULL REFERENCES Communities(id),
    role VARCHAR(20) DEFAULT 'member',
    joined_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    PRIMARY KEY (user_id, community_id)
);

-- Likes Table
CREATE TABLE Likes (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES Users(id),
    post_id INTEGER NOT NULL REFERENCES Posts(id),
    liked_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL
);

-- Messages Table
CREATE TABLE Messages (
    id SERIAL PRIMARY KEY,
    sender_id INTEGER NOT NULL REFERENCES Users(id),
    receiver_id INTEGER NOT NULL REFERENCES Users(id),
    content TEXT NOT NULL,
    sent_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    status VARCHAR(10) DEFAULT 'sent' CHECK (status IN ('sent', 'delivered', 'read'))
);

-- Follows Table
CREATE TABLE Follows (
    follower_id INTEGER NOT NULL REFERENCES Users(id),
    followee_id INTEGER NOT NULL REFERENCES Users(id),
    followed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    PRIMARY KEY (follower_id, followee_id)
);

-- Notifications Table
CREATE TABLE Notifications (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES Users(id),
    type VARCHAR(10) NOT NULL CHECK (type IN ('like', 'comment', 'follow', 'chat')),
    reference_id INTEGER,
    message VARCHAR(255) NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL
);

-- Subtitles Table
CREATE TABLE Subtitles (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL
);

-- User_Subtitles Table
CREATE TABLE User_Subtitles (
    user_id INTEGER NOT NULL REFERENCES Users(id),
    subtitle_id INTEGER NOT NULL REFERENCES Subtitles(id),
    subscribed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    PRIMARY KEY (user_id, subtitle_id)
);

-- LiveStreams Table
CREATE TABLE LiveStreams (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES Users(id),
    title VARCHAR(255) NOT NULL,
    status VARCHAR(10) DEFAULT 'live' NOT NULL CHECK (status IN ('live', 'ended')),
    started_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    ended_at TIMESTAMP WITH TIME ZONE
);

-- Roles Table
CREATE TABLE Roles (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL
);

-- Add appropriate indexes
CREATE INDEX idx_posts_user_id ON Posts(user_id);
CREATE INDEX idx_comments_post_id ON Comments(post_id);
CREATE INDEX idx_comments_user_id ON Comments(user_id);
CREATE INDEX idx_likes_user_id ON Likes(user_id);
CREATE INDEX idx_likes_post_id ON Likes(post_id);
CREATE INDEX idx_messages_sender_id ON Messages(sender_id);
CREATE INDEX idx_messages_receiver_id ON Messages(receiver_id);
CREATE INDEX idx_follows_follower_id ON Follows(follower_id);
CREATE INDEX idx_follows_followee_id ON Follows(followee_id);
CREATE INDEX idx_notifications_user_id ON Notifications(user_id);
CREATE INDEX idx_livestreams_user_id ON LiveStreams(user_id);

-- Enable row level security
ALTER TABLE Users ENABLE ROW LEVEL SECURITY;
ALTER TABLE Posts ENABLE ROW LEVEL SECURITY;
ALTER TABLE Comments ENABLE ROW LEVEL SECURITY;
ALTER TABLE Communities ENABLE ROW LEVEL SECURITY;
ALTER TABLE User_Communities ENABLE ROW LEVEL SECURITY;
ALTER TABLE Likes ENABLE ROW LEVEL SECURITY;
ALTER TABLE Messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE Follows ENABLE ROW LEVEL SECURITY;
ALTER TABLE Notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE Subtitles ENABLE ROW LEVEL SECURITY;
ALTER TABLE User_Subtitles ENABLE ROW LEVEL SECURITY;
ALTER TABLE LiveStreams ENABLE ROW LEVEL SECURITY;
ALTER TABLE Roles ENABLE ROW LEVEL SECURITY;

-- Create basic RLS policies (customize as needed)
CREATE POLICY "Users are viewable by everyone" ON Users FOR SELECT USING (true);
CREATE POLICY "Public posts are viewable by everyone" ON Posts FOR SELECT USING (visibility = 'public');
CREATE POLICY "Comments are viewable by everyone" ON Comments FOR SELECT USING (true);
CREATE POLICY "Public communities are viewable by everyone" ON Communities FOR SELECT USING (visibility = 'public');