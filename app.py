import streamlit as st
import database
import pandas as pd

st.set_page_config(page_title="Blockchain Explorer", layout="wide")

conn = database.get_db_connection()
cursor = conn.cursor()

# Sidebar Menu Options
if "user_id" not in st.session_state:
    menu = ["Login", "Register"]
else:
    menu = ["Blockchain Explorer", "Make Transaction", "Check Balance", "Logout"]

choice = st.sidebar.selectbox("Menu", menu)

# 🔹 REGISTER SECTION
if choice == "Register":
    st.subheader("Register")
    name = st.text_input("Username")
    email = st.text_input("Email")
    password = st.text_input("Password", type="password")

    if st.button("Register"):
        try:
            cursor.execute("INSERT INTO Users (name, email, password) VALUES (%s, %s, %s)", (name, email, password))
            conn.commit()
            st.success("Account created successfully! You can now log in.")
        except Exception as e:
            st.error(f"Registration failed: {e}")

# 🔹 LOGIN SECTION
elif choice == "Login":
    st.subheader("Login")
    email = st.text_input("Email")
    password = st.text_input("Password", type="password")

    if st.button("Login"):
        cursor.execute("SELECT user_id FROM Users WHERE email=%s AND password=%s", (email, password))
        user = cursor.fetchone()
        
        if user:
            st.session_state.user_id = user[0]
            st.rerun()  # 🔹 Fixed rerun issue
        else:
            st.error("Invalid credentials. Please try again.")

# 🔹 MAKE TRANSACTION SECTION
elif choice == "Make Transaction":
    st.subheader("Send Money")

    sender_username = st.text_input("Your Username")
    receiver_username = st.text_input("Receiver Username")
    amount = st.number_input("Amount", min_value=0.01, format="%.2f")

    if st.button("Send Transaction"):
        try:
            cursor.execute("CALL make_transaction(%s, %s, %s)", (sender_username, receiver_username, amount))
            conn.commit()
            st.success(f"Sent {amount} from {sender_username} to {receiver_username}")
        except Exception as e:
            st.error(f"Transaction failed: {e}")

# 🔹 CHECK BALANCE SECTION
elif choice == "Check Balance":
    st.subheader("Check Wallet Balance")

    username = st.text_input("Enter Your Username")

    if st.button("Check Balance"):
        cursor.execute("""
            SELECT balance FROM Wallets 
            WHERE user_id = (SELECT user_id FROM Users WHERE name=%s)
        """, (username,))
        balance = cursor.fetchone()

        if balance:
            st.success(f"Your Current Balance: ${balance[0]:,.2f}")
        else:
            st.error("User not found or wallet does not exist.")

# 🔹 BLOCKCHAIN EXPLORER SECTION (Displays Transactions)
elif choice == "Blockchain Explorer":
    st.subheader("All Transactions")

    cursor.execute("""
        SELECT transaction_hash, block_id, amount, sender_wallet_id, receiver_wallet_id
        FROM Transactions
    """)
    transactions = cursor.fetchall()

    df = pd.DataFrame(transactions, columns=["Tx Hash", "Block ID", "Amount", "Sender", "Receiver"])
    st.dataframe(df)

# 🔹 LOGOUT BUTTON
elif choice == "Logout":
    del st.session_state["user_id"]
    st.success("You have been logged out.")
    st.rerun()  # 🔹 Ensures the user is redirected to the Login page
