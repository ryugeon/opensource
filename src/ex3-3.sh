#!/usr/bin/env bash
set -euo pipefail

scores=("$@")
count=${#scores[@]}

if [ $count -eq 0 ]; then
  echo "사용법: $0 score1 score2 ..." >&2
  exit 1
fi

total_score=0

get_grade() {
    local score_int=$1
    if [ "$score_int" -ge 90 ] && [ "$score_int" -le 100 ]; then
        echo "A"
    elif [ "$score_int" -ge 0 ] && [ "$score_int" -lt 90 ]; then
        echo "B"
    else
        echo "오류"
    fi
}

for score in "${scores[@]}"; do
    if ! [[ "$score" =~ ^[0-9]+$ ]]; then
        echo "오류: 점수는 정수여야 합니다: $score" >&2
        exit 1
    fi
    grade=$(get_grade "$score")
    total_score=$(( total_score + score ))
    echo "점수 $score: $grade 등급"
done

avg_score=$(( total_score / count ))
avg_grade=$(get_grade "$avg_score")

echo "2) 평균 점수: $avg_score"
echo "2) 평균 등급: $avg_grade"

