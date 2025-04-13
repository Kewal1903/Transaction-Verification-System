Introduction
•
Database management systems (DBMS) play a crucial role in securely storing and managing transaction records. However, traditional relational databases are often centralized, making them vulnerable to fraud, data tampering, and single points of failure. Ensuring transaction integrity within a database environment requires mechanisms to prevent unauthorized modifications and ensure data consistency.
•
This project will implement a SQL-based transaction verification system that incorporates immutable data storage, cryptographic hashing, and automated validation using MySQL and PL/SQL.
•
The objective is to create a tamper-proof, verifiable transaction system within a structured database, ensuring that all recorded transactions are valid, irreversible, and linked in a sequential manner.
Methodology and Implementation
•
The system will be designed using MySQL and PL/SQL where the core components will include four primary tables: Users, Transactions, Wallets, and Blocks.
o
The Users table will store details such as user_id, name, and email.
o
The Wallets table will maintain wallet_id, user_id, and balance, ensuring proper account tracking.
o
The Transactions table will record transaction_id, sender_wallet_id, receiver_wallet_id, amount, and timestamp, ensuring a structured ledger of all financial activities. Each transaction will also be cryptographically hashed with an SHA-256 cryptographic hash generated using DBMS_CRYPTO functions.
o
The Blocks table will store block_id, previous_block_hash, nonce, and timestamp, linking transactions in a sequential manner to enforce immutability.
•
Transaction records will be linked through a previous transaction hash, ensuring data integrity and immutability within the database. A simulated Proof-of-Work (PoW) mechanism will be introduced using PL/SQL procedures, where a simple nonce-generation algorithm will verify transaction authenticity before committing changes to the database.
•
Triggers and stored procedures will handle transaction validation, ensuring that users have sufficient balances and preventing issues such as double-spending. These database
mechanisms will enforce strict integrity constraints to maintain consistent financial
records.
•
A basic frontend interface will be developed using Streamlit handling backend connectivity, enabling user interaction with the transaction system.
Expected Results and Significance
•
The system is expected to securely store and verify transactions while maintaining data consistency and integrity through cryptographic hashing techniques.
•
The Proof-of-Work mechanism will serve as an additional security layer, preventing unauthorized transaction modifications and ensuring that each recorded transaction undergoes verification before database storage.
•
By implementing triggers, stored functions, and relational constraints, the project will demonstrate how a database can simulate blockchain-like security without requiring external blockchain frameworks, making it a practical approach for secure transaction management.
Conclusion and Future Enhancements
•
The project will establish a tamper-proof transaction ledger within a relational database system, proving that secure transaction validation and linking can be achieved using SQL-based methodologies.
•
The integration of hashing, block referencing, and automatic validation through stored procedures and triggers will ensure that transactions remain secure, verifiable, and immutable over time.
•
Future enhancements could include automated auditing mechanisms, Merkle tree-based indexing for faster lookups, and dynamic difficulty adjustment to improve transaction verification efficiency.

