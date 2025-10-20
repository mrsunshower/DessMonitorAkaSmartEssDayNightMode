#!/bin/bash

# -------- Configuration --------
# Replace these values only if running locally and not using GitHub Actions
# DESS_USER="your_dess_login"
# DESS_PASS="your_dess_pass"
# DESS_COMPANY_KEY="your_company_key"
# DEVICE_PN="your_pn"
# DEVICE_SN="your_sn"
# DEVICE_CODE="your_device_code"
# DEVICE_ADDR="your_device_addr"

# Function to calculate SHA1 hash of input string
sha1() {
  printf "%s" "$1" | openssl sha1 | awk '{print $2}'
}

# Authenticate and get TOKEN and SECRET from Dess Monitor API
auth() {
  SALT=$(date +%s%3N)
  SHA1_PASS=$(echo -n "$DESS_PASS" | openssl sha1 | awk '{print $2}')
  SIGN_STRING="${SALT}${SHA1_PASS}&action=authSource&usr=${DESS_USER}&source=1&company-key=${DESS_COMPANY_KEY}"
  SIGN=$(sha1 "$SIGN_STRING")

  URL="https://web.dessmonitor.com/public/?sign=${SIGN}&salt=${SALT}&action=authSource&usr=${DESS_USER}&source=1&company-key=${DESS_COMPANY_KEY}"

  RESPONSE=$(curl -s "$URL")
  SECRET=$(echo "$RESPONSE" | jq -r '.dat.secret')
  TOKEN=$(echo "$RESPONSE" | jq -r '.dat.token')

  if [ -z "$TOKEN" ] || [ "$TOKEN" == "null" ]; then
    echo "Failed to get token. Server response:"
    echo "$RESPONSE"
    exit 1
  fi
}

# Generate signature for authenticated API requests
generate_sign() {
  local salt=$1
  local secret=$2
  local token=$3
  local action=$4
  sha1 "${salt}${secret}${token}${action}"
}

# Send control command to inverter for specified id and value
send_cmd() {
  local id=$1
  local val=$2

  SALT=$(date +%s%3N)
  ACTION="&action=ctrlDevice&source=1&pn=${DEVICE_PN}&sn=${DEVICE_SN}&devcode=${DEVICE_CODE}&devaddr=${DEVICE_ADDR}&id=${id}&val=${val}&i18n=en_US"
  SIGN=$(generate_sign "$SALT" "$SECRET" "$TOKEN" "$ACTION")

  URL="https://web.dessmonitor.com/public/?sign=${SIGN}&salt=${SALT}&token=${TOKEN}${ACTION}"

  echo "Sending: $id -> $val"
  curl -s "$URL"
}

MODE=$1
if [ -z "$MODE" ]; then
  echo "Usage: $0 day|night"
  exit 1
fi

auth

if [ "$MODE" = "day" ]; then
  send_cmd "los_output_source_priority" 2
  send_cmd "bat_charger_source_priority" 2
elif [ "$MODE" = "night" ]; then
  send_cmd "los_output_source_priority" 0
  send_cmd "bat_charger_source_priority" 1
else
  echo "Unknown mode: $MODE. Use day or night."
  exit 1
fi
