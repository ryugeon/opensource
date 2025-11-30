#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<EOF
Usage: $0 <command> [options...]
Example: $0 ls -la /tmp
This script defines an internal function that builds a command string
from the provided command and options, then executes it using eval.
Be careful: eval runs the constructed command.
EOF
}

if [ "$#" -lt 1 ]; then
  usage
  exit 1
fi

cmd="$1"; shift
opts=("$@")

# 내부 함수: 명령과 옵션을 받아서 eval로 실행
run_cmd() {
  local name="$1"; shift
  local args=("$@")

  # 안전하게 각 인자를 쉘 인용 형태로 변환
  local quoted=""
  for a in "${args[@]}"; do
    # printf %q는 bash에서 인용된 토큰을 생성
    quoted+=" $(printf '%q' "$a")"
  done

  local cmdstr
  cmdstr="$(printf '%q' "$name")${quoted}"

  echo "Executing: $cmdstr"
  # eval로 실제 명령 실행
  eval "$cmdstr"
}

# 호출
run_cmd "$cmd" "${opts[@]:-}"

exit 0
