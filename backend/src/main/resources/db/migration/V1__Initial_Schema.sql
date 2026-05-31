-- 1. Table Utilisateurs
CREATE TABLE users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    uuid VARCHAR(36) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    pseudo VARCHAR(50) NOT NULL UNIQUE,
    avatar VARCHAR(255),
    bio TEXT,
    country VARCHAR(50),
    region VARCHAR(50),
    birth_date DATE,
    gender VARCHAR(20),
    role VARCHAR(20) NOT NULL,
    status VARCHAR(20) DEFAULT 'ACTIVE',
    is_premium BOOLEAN DEFAULT FALSE,
    is_verified BOOLEAN DEFAULT FALSE,
    is_2fa_enabled BOOLEAN DEFAULT FALSE,
    is_online BOOLEAN DEFAULT FALSE,
    last_seen DATETIME DEFAULT CURRENT_TIMESTAMP,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at DATETIME
);

-- 2. Table Profils Joueurs
CREATE TABLE player_profiles (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL UNIQUE,
    bio TEXT,
    level VARCHAR(20) NOT NULL,
    availability VARCHAR(255),
    discord VARCHAR(100),
    steam VARCHAR(100),
    riot_id VARCHAR(100),
    xbox_gamertag VARCHAR(100),
    psn VARCHAR(100),
    reputation_score DOUBLE DEFAULT 5.0,
    total_reviews INT DEFAULT 0,
    matches_played INT DEFAULT 0,
    matches_won INT DEFAULT 0,
    win_rate DOUBLE DEFAULT 0.0,
    hours_played INT DEFAULT 0,
    favorite_role VARCHAR(50),
    current_streak INT DEFAULT 0,
    CONSTRAINT fk_profile_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE profile_languages (
    profile_id BIGINT NOT NULL,
    language VARCHAR(50) NOT NULL,
    PRIMARY KEY (profile_id, language),
    CONSTRAINT fk_lang_profile FOREIGN KEY (profile_id) REFERENCES player_profiles(id)
);

CREATE TABLE profile_badges (
    profile_id BIGINT NOT NULL,
    badge VARCHAR(50) NOT NULL,
    PRIMARY KEY (profile_id, badge),
    CONSTRAINT fk_badge_profile FOREIGN KEY (profile_id) REFERENCES player_profiles(id)
);

-- 3. Table Jeux
CREATE TABLE games (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    slug VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    logo VARCHAR(255),
    banner VARCHAR(255),
    category VARCHAR(50),
    is_popular BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE game_platforms (
    game_id BIGINT NOT NULL,
    platform VARCHAR(50) NOT NULL,
    PRIMARY KEY (game_id, platform),
    CONSTRAINT fk_platform_game FOREIGN KEY (game_id) REFERENCES games(id)
);

-- 4. Social & Teams
CREATE TABLE friends (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    friend_id BIGINT NOT NULL,
    status VARCHAR(20) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uk_friendship (user_id, friend_id),
    CONSTRAINT fk_friend_user FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE teams (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    logo VARCHAR(255),
    description TEXT,
    owner_id BIGINT NOT NULL,
    max_members INT DEFAULT 5,
    visibility VARCHAR(20) DEFAULT 'PUBLIC',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_team_owner FOREIGN KEY (owner_id) REFERENCES users(id)
);

CREATE TABLE team_members (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    team_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    role VARCHAR(20) NOT NULL,
    joined_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uk_team_member (team_id, user_id),
    CONSTRAINT fk_tm_team FOREIGN KEY (team_id) REFERENCES teams(id) ON DELETE CASCADE,
    CONSTRAINT fk_tm_user FOREIGN KEY (user_id) REFERENCES users(id)
);

-- 5. Chat
CREATE TABLE conversations (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    type VARCHAR(20) NOT NULL,
    team_id BIGINT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE conversation_participants (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    conversation_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    last_read_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    joined_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uk_participant (conversation_id, user_id),
    CONSTRAINT fk_part_conv FOREIGN KEY (conversation_id) REFERENCES conversations(id) ON DELETE CASCADE
);

CREATE TABLE messages (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    conversation_id BIGINT NOT NULL,
    sender_id BIGINT NOT NULL,
    content TEXT NOT NULL,
    message_type VARCHAR(20) DEFAULT 'TEXT',
    is_read BOOLEAN DEFAULT FALSE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_conv_date (conversation_id, created_at),
    CONSTRAINT fk_msg_conv FOREIGN KEY (conversation_id) REFERENCES conversations(id) ON DELETE CASCADE
);

-- 6. Autres
CREATE TABLE audit_logs (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT,
    action VARCHAR(255) NOT NULL,
    details TEXT,
    ip_address VARCHAR(45),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE verification_tokens (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    token VARCHAR(255) NOT NULL UNIQUE,
    user_id BIGINT NOT NULL UNIQUE,
    expiry_date DATETIME NOT NULL,
    CONSTRAINT fk_vt_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE refresh_tokens (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    token VARCHAR(255) NOT NULL UNIQUE,
    user_id BIGINT NOT NULL UNIQUE,
    expiry_date TIMESTAMP NOT NULL,
    CONSTRAINT fk_rt_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
