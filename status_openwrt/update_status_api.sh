#!/usr/bin/env ash

# Include configuration and lib
. $(dirname $(readlink -f $0))/config/config.sh || exit 1
. $(dirname $(readlink -f $0))/lib/devices.sh || exit 1
. $(dirname $(readlink -f $0))/lib/state.sh || exit 1
. $(dirname $(readlink -f $0))/lib/users.sh || exit 1

generate_json_output_api() {

  # JSON Output
  echo "{"
  echo "  \"sensors\": {"
  echo "    \"people_now_present\": [{"
  echo "      \"value\": $(users_get_count),"
  echo "      \"names\": [$(users_get_names)]"
  echo "    }]"
  echo "  },"
  echo "  \"state\": {"
  echo "    \"open\": $(open_state),"
  echo "    \"lastchange\": $(devices_get_last_change)",
  echo "    \"message\": \"$(connected_devices_message)\""
  echo "  }"
  echo "}"
}

generate_json_output_api | \
  curl \
    $CURL_EXTRA_OPTIONS \
    --silent \
    --connect-timeout 5 \
    --max-time 10 \
    --retry 3 \
    --retry-delay 5 \
    --request PUT \
    --header "Content-Type: application/json" \
    --header "Accept: application/json" \
    --header "X-Hackspace-API-Key: ${API_KEY}" \
    --data-ascii @- \
    ${API_URL} > /dev/null
