-- USERS TABLE
CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL, -- Hashed password
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- WALLETS TABLE
CREATE TABLE Wallets (
    wallet_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    balance DECIMAL(20,8) DEFAULT 0 NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- BLOCKS TABLE
CREATE TABLE Blocks (
    block_id INT AUTO_INCREMENT PRIMARY KEY,
    block_hash VARCHAR(64) UNIQUE NOT NULL,
    previous_block_id INT DEFAULT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    nonce INT NOT NULL,
    FOREIGN KEY (previous_block_id) REFERENCES Blocks(block_id) ON DELETE CASCADE
);

-- TRANSACTIONS TABLE
CREATE TABLE Transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    block_id INT DEFAULT NULL,
    amount DECIMAL(20,8) CHECK (amount > 0) NOT NULL,
    sender_wallet_id INT NOT NULL,
    receiver_wallet_id INT NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    transaction_hash VARCHAR(64) UNIQUE NOT NULL,
    FOREIGN KEY (block_id) REFERENCES Blocks(block_id) ON DELETE SET NULL,
    FOREIGN KEY (sender_wallet_id) REFERENCES Wallets(wallet_id) ON DELETE CASCADE,
    FOREIGN KEY (receiver_wallet_id) REFERENCES Wallets(wallet_id) ON DELETE CASCADE
);
