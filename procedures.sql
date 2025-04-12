DELIMITER $$

CREATE PROCEDURE mine_block()
BEGIN
    DECLARE prev_block_hash VARCHAR(64);
    DECLARE new_block_hash VARCHAR(64);
    DECLARE mined_nonce INT DEFAULT 0;
    DECLARE curtime TIMESTAMP;
    DECLARE difficulty VARCHAR(4) DEFAULT '0000';

    -- Get the latest block hash
    SELECT block_hash INTO prev_block_hash FROM Blocks ORDER BY block_id DESC LIMIT 1;

    -- If there is no previous block, set a default value
    IF prev_block_hash IS NULL THEN
        SET prev_block_hash = '0000000000000000000000000000000000000000000000000000000000000000';
    END IF;

    SET curtime = NOW();

    -- Simulated Proof-of-Work loop
    REPEAT
        SET new_block_hash = generate_hash(CONCAT(prev_block_hash, mined_nonce, curtime));

        -- Check if the block meets the difficulty requirement
        IF LEFT(new_block_hash, 4) = difficulty THEN
            LEAVE;
        ELSE
            SET mined_nonce = mined_nonce + 1;
        END IF;
    UNTIL FALSE END REPEAT;

    -- Insert new block
    INSERT INTO Blocks (block_hash, previous_block_id, timestamp, nonce) 
    VALUES (new_block_hash, (SELECT MAX(block_id) FROM Blocks), curtime, mined_nonce);
    
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE make_transaction(
    IN sender_username VARCHAR(100),
    IN receiver_username VARCHAR(100),
    IN amount DECIMAL(20,8)
)
BEGIN
    DECLARE sender_wallet_id INT;
    DECLARE receiver_wallet_id INT;
    
    -- Get sender wallet ID
    SELECT wallet_id INTO sender_wallet_id FROM Wallets WHERE user_id = (SELECT user_id FROM Users WHERE name = sender_username) LIMIT 1;
    
    -- Get receiver wallet ID
    SELECT wallet_id INTO receiver_wallet_id FROM Wallets WHERE user_id = (SELECT user_id FROM Users WHERE name = receiver_username) LIMIT 1;

    -- Insert transaction
    INSERT INTO Transactions (block_id, amount, sender_wallet_id, receiver_wallet_id, timestamp, transaction_hash)
    VALUES (NULL, amount, sender_wallet_id, receiver_wallet_id, NOW(), SHA2(CONCAT(sender_wallet_id, receiver_wallet_id, amount, NOW()), 256));
    
    COMMIT;
END$$

DELIMITER ;
