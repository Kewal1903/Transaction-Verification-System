DELIMITER $$

CREATE TRIGGER before_transaction_insert 
BEFORE INSERT ON Transactions
FOR EACH ROW
BEGIN
    DECLARE sender_balance DECIMAL(20,8);

    -- Check sender wallet balance
    SELECT balance INTO sender_balance FROM Wallets WHERE wallet_id = NEW.sender_wallet_id;
    
    IF sender_balance < NEW.amount THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Insufficient balance';
    END IF;

    -- Deduct balance from sender
    UPDATE Wallets SET balance = balance - NEW.amount WHERE wallet_id = NEW.sender_wallet_id;

    -- Add balance to receiver
    UPDATE Wallets SET balance = balance + NEW.amount WHERE wallet_id = NEW.receiver_wallet_id;

    -- Generate transaction hash
    SET NEW.transaction_hash = generate_hash(CONCAT(NEW.sender_wallet_id, NEW.receiver_wallet_id, NEW.amount, NEW.timestamp));
END$$

DELIMITER ;


DELIMITER $$

CREATE TRIGGER validate_transaction BEFORE INSERT ON Transactions
FOR EACH ROW
BEGIN
    DECLARE sender_exists INT;
    DECLARE receiver_exists INT;

    SELECT COUNT(*) INTO sender_exists FROM Wallets WHERE wallet_id = NEW.sender_wallet_id;
    SELECT COUNT(*) INTO receiver_exists FROM Wallets WHERE wallet_id = NEW.receiver_wallet_id;

    IF sender_exists = 0 OR receiver_exists = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid sender or receiver wallet';
    END IF;
END$$

DELIMITER ;
