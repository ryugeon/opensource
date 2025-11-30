#!/usr/bin/env bash
set -euo pipefail

# ex3-9.sh
# 팀원 관리 시스템 - DB.txt 기반
# 기능: 팀원 정보 추가, 팀원과 한 일 기록, 팀원/날짜별 검색

DB_FILE="DB.txt"
ACTIVITY_FILE="activity.txt"

# DB.txt 포맷: name|birthday_or_phone
# activity.txt 포맷: name|date|activity

init_db() {
  [ -f "$DB_FILE" ] || touch "$DB_FILE"
  [ -f "$ACTIVITY_FILE" ] || touch "$ACTIVITY_FILE"
}

show_menu() {
  cat <<EOF

======================
1) 팀원 정보 추가
2) 팀원과 한 일 기록
3) 팀원 검색
4) 수행 내용 검색
5) 종료
======================
EOF
}

# 1. 팀원 정보 추가
add_member() {
  echo ""
  read -p "팀원 이름을 입력하세요: " name
  read -p "전화번호를 입력하세요: " contact
  
  if [ -z "$name" ] || [ -z "$contact" ]; then
    echo "오류: 이름과 전화번호가 필요합니다."
    return 1
  fi
  
  # 중복 확인
  if grep -q "^${name}|" "$DB_FILE" 2>/dev/null; then
    echo "오류: 팀원 '$name'이(가) 이미 존재합니다."
    return 1
  fi
  
  echo "${name}|${contact}" >> "$DB_FILE"
  echo "✓ 추가됨: $name ($contact)"
}

# 2. 팀원과 한 일 기록
record_activity() {
  echo ""
  read -p "Enter team member name: " name
  read -p "Enter date (YYYY-MM-DD): " date
  read -p "Enter activity: " activity
  
  if [ -z "$name" ] || [ -z "$date" ] || [ -z "$activity" ]; then
    echo "오류: 모든 필드가 필요합니다."
    return 1
  fi
  
  # 팀원 존재 확인
  if ! grep -q "^${name}|" "$DB_FILE" 2>/dev/null; then
    echo "오류: 팀원 '$name'을(를) 찾을 수 없습니다."
    return 1
  fi
  
  echo "${name}|${date}|${activity}" >> "$ACTIVITY_FILE"
  echo "✓ 기록됨: $name - $date - $activity"
}

# 3. 팀원 정보 검색
search_member() {
  echo ""
  read -p "Enter team member name to search: " search_name
  
  if [ -z "$search_name" ]; then
    echo "Error: Name is required."
    return 1
  fi
  
  echo ""
  echo "=== 팀원 검색 결과 ==="
  if grep "^${search_name}|" "$DB_FILE" 2>/dev/null; then
    # 해당 팀원의 활동도 함께 표시
    echo ""
    echo "수행 내용:"
    grep "^${search_name}|" "$ACTIVITY_FILE" 2>/dev/null | awk -F'|' '{print "  " $2 " - " $3}' || echo "  (기록된 수행 내용 없음)"
  else
    echo "팀원 '$search_name'을(를) 찾을 수 없습니다."
  fi
}

# 4. 날짜별 수행 내용 검색
search_activity() {
  echo ""
  read -p "Enter date to search (YYYY-MM-DD): " search_date
  
  if [ -z "$search_date" ]; then
    echo "Error: Date is required."
    return 1
  fi
  
  echo ""
  echo "=== $search_date의 수행 내용 ==="
  if grep "|${search_date}|" "$ACTIVITY_FILE" 2>/dev/null; then
    :
  else
    echo "$search_date에 기록된 수행 내용이 없습니다."
  fi
}

# 메인 루프
main() {
  init_db
  
  while true; do
    show_menu
    read -p "Select (1-5): " choice
    case $choice in
      1) add_member ;;
      2) record_activity ;;
      3) search_member ;;
      4) search_activity ;;
      5) echo "Exiting..."; break ;;
      *) echo "Invalid choice. Please select 1-5." ;;
    esac
  done
}

main
exit 0
