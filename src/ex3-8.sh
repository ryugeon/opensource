#!/usr/bin/env bash
set -euo pipefail

# ex3-8.sh
# 디렉토리/파일 관리 시스템
# 1. "DB" 폴더 확인 및 생성
# 2. DB 폴더에 임의의 5개 파일 생성 후 압축
# 3. "train" 폴더 생성 및 DB의 파일 5개와 링크

BASE_DIR="$(pwd)"
DB_DIR="${BASE_DIR}/DB"
TRAIN_DIR="${BASE_DIR}/train"

echo "=== Directory/File Management System ==="
echo ""

# 1. DB 폴더 확인 및 생성
echo "1) Checking/Creating DB folder..."
if [ -d "$DB_DIR" ]; then
  echo "   DB folder already exists: $DB_DIR"
else
  mkdir -p "$DB_DIR"
  echo "   Created DB folder: $DB_DIR"
fi
echo ""

# 2. DB 폴더에 5개의 임의 파일 생성
echo "2) Creating 5 files in DB folder..."
for i in {1..5}; do
  FILE_PATH="${DB_DIR}/${i}.txt"
  if [ ! -f "$FILE_PATH" ]; then
    # 파일명: n.txt, 내용: "안녕하세요 류건입니다n"
    echo "안녕하세요 류건입니다${i}" > "$FILE_PATH"
    echo "   Created: $FILE_PATH"
  else
    echo "   File already exists: $FILE_PATH"
  fi
done
echo ""

# 3. DB 폴더의 파일 압축
echo "3) Compressing DB folder..."
ARCHIVE_PATH="${BASE_DIR}/DB_backup.tar.gz"
if [ -f "$ARCHIVE_PATH" ]; then
  echo "   Archive already exists: $ARCHIVE_PATH"
else
  tar -czf "$ARCHIVE_PATH" -C "$BASE_DIR" DB/
  echo "   Created archive: $ARCHIVE_PATH"
fi
echo ""

# 4. train 폴더 생성 및 링크
echo "4) Creating train folder and linking DB files..."
if [ -d "$TRAIN_DIR" ]; then
  echo "   train folder already exists: $TRAIN_DIR"
else
  mkdir -p "$TRAIN_DIR"
  echo "   Created train folder: $TRAIN_DIR"
fi

# DB의 5개 파일을 train 폴더에 심볼릭 링크
for i in {1..5}; do
  FILE_NAME="${i}.txt"
  DB_FILE="${DB_DIR}/${FILE_NAME}"
  LINK_PATH="${TRAIN_DIR}/${FILE_NAME}"
  
  if [ -f "$DB_FILE" ]; then
    if [ ! -L "$LINK_PATH" ]; then
      ln -s "$DB_FILE" "$LINK_PATH"
      echo "   Created symbolic link: $LINK_PATH -> $DB_FILE"
    else
      echo "   Symbolic link already exists: $LINK_PATH"
    fi
  fi
done
echo ""

# 5. 최종 상태 출력
echo "=== Final Status ==="
echo "DB folder contents:"
ls -lah "$DB_DIR" | tail -n +4
echo ""
echo "train folder contents:"
ls -lah "$TRAIN_DIR" | tail -n +4
echo ""
echo "Archive info:"
ls -lh "$ARCHIVE_PATH"
echo ""
echo "=== Completed ==="

exit 0
