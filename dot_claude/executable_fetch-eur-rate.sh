#!/bin/bash
set -euo pipefail

# Fetches the current USD→EUR rate from api.frankfurter.app (ECB data, no API key)
# and caches it to ~/.cache/claude-eur-rate for use by statusline.sh.
# Invoked by the fetch-eur-rate.service systemd user unit every 6 hours.

CACHE_FILE="$HOME/.cache/claude-eur-rate"

rate=$(curl -sf --max-time 10 'https://api.frankfurter.app/latest?from=USD&to=EUR' \
    | jq -r '.rates.EUR') || {
    echo "fetch-eur-rate: network fetch failed, keeping existing cache" >&2
    exit 0
}

if [[ "$rate" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
    printf '%s\n' "$rate" > "$CACHE_FILE"
else
    echo "fetch-eur-rate: unexpected rate format: ${rate}" >&2
    exit 1
fi
