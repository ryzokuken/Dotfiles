#!/usr/bin/env bash
set -u
INPUT="$(cat)"
export INPUT_JSON="$INPUT"

__sgr() { printf '\033[%sm' "$1"; }
__reset() { printf '\033[0m'; }

if command -v jq >/dev/null 2>&1; then
  __field() {
    printf '%s' "$INPUT_JSON" | jq -r --arg p "$1" '
      ($p | split(".")) as $parts
      | reduce $parts[] as $k (.; if type == "object" and has($k) then .[$k] else null end)
      | if . == null then "" else (if type == "string" then . else tostring end) end
    ' 2>/dev/null
  }
else
  if command -v python3 >/dev/null 2>&1 && python3 -c 'import sys' >/dev/null 2>&1; then
    __PY=python3
  elif command -v python >/dev/null 2>&1; then
    __PY=python
  else
    __PY=""
  fi
  __field() {
    if [ -z "$__PY" ]; then
      printf ''
      return
    fi
    PATH_ARG="$1" "$__PY" - <<'PYEOF' 2>/dev/null
import json, os
d = json.loads(os.environ.get('INPUT_JSON','{}') or '{}')
p = os.environ.get('PATH_ARG','')
cur = d
for part in p.split('.'):
    if isinstance(cur, dict) and part in cur:
        cur = cur[part]
    else:
        cur = None
        break
if cur is None:
    print('', end='')
elif isinstance(cur, bool):
    print('true' if cur else 'false', end='')
else:
    print(cur, end='')
PYEOF
  }
fi

__basename() {
  local s="$1"
  printf '%s' "${s##*/}"
}
__bar() {
  local pct="$1" width="$2" filled="$3" empty="$4"
  local p i n=0 e=0
  p=${pct%.*}
  [ -z "$p" ] && p=0
  if [ "$p" -lt 0 ]; then p=0; fi
  if [ "$p" -gt 100 ]; then p=100; fi
  n=$(((p * width + 50) / 100))
  e=$((width - n))
  local out=""
  for ((i = 0; i < n; i++)); do out+="$filled"; done
  for ((i = 0; i < e; i++)); do out+="$empty"; done
  printf '%s' "$out"
}
__git_branch() {
  local cwd
  cwd="$(__field workspace.current_dir)"
  if [ -z "$cwd" ]; then cwd="$(__field cwd)"; fi
  if [ -n "$cwd" ] && command -v git >/dev/null 2>&1; then
    git -C "$cwd" rev-parse --abbrev-ref HEAD 2>/dev/null
  else
    __field workspace.git_worktree
  fi
}
__emit() {
  local style="$1" text="$2"
  if [ -n "$style" ]; then __sgr "$style"; fi
  printf '%s' "$text"
  if [ -n "$style" ]; then __reset; fi
}
__tick() {
  if [ -n "${STATUSLINE_CLOCK_OVERRIDE:-}" ]; then
    printf '%s' "$STATUSLINE_CLOCK_OVERRIDE"
  else
    date +%s
  fi
}
__rel_time() {
  local target="$1"
  if [ -z "$target" ]; then
    printf ''
    return
  fi
  case "$target" in
  '' | *[!0-9.-]*)
    printf ''
    return
    ;;
  esac
  local t_int="${target%.*}"
  if [ -z "$t_int" ] || [ "$t_int" = "-" ]; then
    printf ''
    return
  fi
  local now diff h m s rem
  now=$(__tick)
  diff=$((t_int - now))
  if [ "$diff" -le 0 ]; then
    printf ''
    return
  fi
  if [ "$diff" -lt 60 ]; then
    printf 'T-%ds' "$diff"
    return
  fi
  if [ "$diff" -lt 3600 ]; then
    m=$((diff / 60))
    s=$((diff % 60))
    printf 'T-%dm%02ds' "$m" "$s"
    return
  fi
  h=$((diff / 3600))
  rem=$(((diff % 3600) / 60))
  printf 'T-%dh%02dm' "$h" "$rem"
}
__cost_eur() {
  # Cost in EUR. Rate is cached by fetch-eur-rate.service; 0.93 is a stale-safe
  # fallback so the field never disappears when the fetch has not run yet.
  local usd rate cache="$HOME/.cache/claude-eur-rate"
  usd="$(__field 'cost.total_cost_usd')"
  case "$usd" in
  '' | *[!0-9.]*)
    printf ''
    return
    ;;
  esac
  rate=0.93
  if [ -r "$cache" ]; then
    local cached
    cached="$(cat "$cache" 2>/dev/null)"
    case "$cached" in
    '' | *[!0-9.]*) ;;
    *) rate="$cached" ;;
    esac
  fi
  awk -v u="$usd" -v r="$rate" 'BEGIN { printf "%.2f", u * r }'
}
__emit '38;2;198;160;246;49' '['
__v="$(__field 'workspace.current_dir')"
__v="$(__basename "$__v")"
__emit '38;2;198;160;246;49' "$__v"
__emit '38;2;198;160;246;49' ']'
__emit '38;2;238;212;159;49' ':'
__out="$(__git_branch)"
__emit '38;2;238;212;159;49' "$__out"
__emit '2;38;2;202;211;245' ' · '
__v="$(__field 'model.display_name')"
__emit '1;38;2;245;169;127;49' "$__v"
__emit '2;38;2;202;211;245' ' / '
if [ "$(__field 'thinking.enabled')" = 'true' ]; then
  __v="$(__field 'effort.level')"
  __emit '2;38;2;202;211;245' "$__v"
fi
__reset
printf '\n'
__reset
__emit '38;2;138;173;244' 'ctx '
__v="$(__field 'context_window.used_percentage')"
__bar_out="$(__bar "$__v" 20 '━' '─')"
__emit '38;2;138;173;244' "$__bar_out"
__emit '38;2;138;173;244' ' '
__v="$(__field 'context_window.used_percentage')"
__emit '38;2;138;173;244' "$__v"
__emit '38;2;138;173;244' '%'
__emit '2;38;2;202;211;245' ' · '
__emit '38;2;166;218;149' '5h '
__v="$(__field 'rate_limits.five_hour.used_percentage')"
__bar_out="$(__bar "$__v" 10 '━' '─')"
__emit '38;2;166;218;149' "$__bar_out"
__emit '38;2;166;218;149' ' '
__v="$(__field 'rate_limits.five_hour.used_percentage')"
__emit '38;2;166;218;149' "$__v"
__emit '38;2;166;218;149' '%'
__v="$(__rel_time "$(__field 'rate_limits.five_hour.resets_at')")"
if [ -n "$__v" ]; then
  __emit '38;2;166;218;149' ' '
  __emit '2;38;2;166;218;149' "$__v"
fi
__emit '2;38;2;202;211;245' ' · '
__emit '38;2;166;218;149' '7d '
__v="$(__field 'rate_limits.seven_day.used_percentage')"
__bar_out="$(__bar "$__v" 10 '━' '─')"
__emit '38;2;166;218;149' "$__bar_out"
__emit '38;2;166;218;149' ' '
__v="$(__field 'rate_limits.seven_day.used_percentage')"
__emit '38;2;166;218;149' "$__v"
__emit '38;2;166;218;149' '%'
__v="$(__cost_eur)"
if [ -n "$__v" ]; then
  __emit '2;38;2;202;211;245' ' · '
  __emit '38;2;238;212;159' "€$__v"
fi

exit 0
