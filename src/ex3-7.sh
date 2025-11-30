#!/usr/bin/env bash
set -euo pipefail

# ex3-7.sh
# 리눅스 시스템 상태 확인 명령어를 활용한 메뉴 기반 시스템 모니터링

show_menu() {
  cat <<EOF

====== System Status Monitor ======
1) User Information
2) GPU/CPU Usage
3) Memory Usage
4) Disk Usage
5) Exit
===================================
EOF
}

# 1. 사용자 정보
user_info() {
  echo "=== User Information ==="
  whoami
  id
  echo ""
}

# 2. GPU 또는 CPU 사용률
gpu_cpu_usage() {
  echo "=== GPU/CPU Usage ==="
  if command -v nvidia-smi &>/dev/null; then
    echo "GPU Info (nvidia-smi):"
    nvidia-smi --query-gpu=index,name,driver_version,memory.total,memory.used,memory.free,temperature.gpu,utilization.gpu,utilization.memory --format=csv,noheader
  else
    echo "NVIDIA GPU not found. Using CPU info instead:"
    lscpu | grep -E "^(Model name|CPU\(s\)|Thread|Socket)"
  fi
  echo ""
  echo "CPU Usage (top - brief):"
  top -bn1 | head -n 3
  echo ""
}

# 3. 메모리 사용량
memory_usage() {
  echo "=== Memory Usage ==="
  if command -v free &>/dev/null; then
    free -h
  else
    echo "free command not available"
  fi
  echo ""
}

# 4. 디스크 사용량
disk_usage() {
  echo "=== Disk Usage ==="
  echo "Filesystem usage (df):"
  df -h
  echo ""
  echo "Current directory usage (du):"
  du -sh .
  echo ""
}

# 메인 루프
main() {
  while true; do
    show_menu
    read -p "Select (1-5): " choice
    case $choice in
      1) user_info ;;
      2) gpu_cpu_usage ;;
      3) memory_usage ;;
      4) disk_usage ;;
      5) echo "Exiting..."; break ;;
      *) echo "Invalid choice. Please select 1-5." ;;
    esac
  done
}

main
exit 0
