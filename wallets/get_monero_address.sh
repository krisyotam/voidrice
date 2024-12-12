#!/bin/bash

# Path to your Monero CLI wallet executable
WALLET_CLI="monero-wallet-cli"

# Wallet file and daemon configuration
WALLET_NAME="khr1st"
DAEMON_ADDRESS="127.0.0.1:18081" # Change if using a remote node

# Email configuration
EMAIL_RECIPIENT="krisyotam@protonmail.com"
EMAIL_SUBJECT="Monero Wallet Address"
EMAIL_BODY="wallet_address.txt"
SMTP_CONFIG="~/.msmtprc" # Path to your SMTP config file for msmtp

# Generate the wallet address
$WALLET_CLI --wallet-file "$WALLET_NAME" --daemon-address "$DAEMON_ADDRESS" --command address > "$EMAIL_BODY"
if [ $? -ne 0 ]; then
  echo "Failed to retrieve wallet address. Ensure the wallet is accessible and daemon is running."
  exit 1
fi

# Extract address (optional: parse output to ensure clean address format)
ADDRESS=$(grep -Eo '[48][0-9A-Za-z]{93}' "$EMAIL_BODY")
if [ -z "$ADDRESS" ]; then
  echo "Failed to parse wallet address from output."
  exit 1
fi

# Send the email with the wallet address
cat <<EOF | msmtp --file="$SMTP_CONFIG" -t
To: $EMAIL_RECIPIENT
Subject: $EMAIL_SUBJECT

Here is the wallet address:
$ADDRESS
EOF

if [ $? -eq 0 ]; then
  echo "Wallet address sent successfully to $EMAIL_RECIPIENT."
else
  echo "Failed to send the email. Check your email configuration."
  exit 1
fi
