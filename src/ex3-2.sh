#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -eq 0 ]; then
    echo "사용법: $0 숫자 [...]
계산: y = 0.5 * x * x (소수점 4자리 출력)" >&2
    exit 1
fi

for x in "$@"; do
        # 숫자 입력인지 간단 검사(정수/소수 허용)
        if ! [[ "$x" =~ ^-?[0-9]+(\.[0-9]+)?$ ]]; then
                echo "경고: '$x' 는 숫자가 아니므로 건너뜁니다." >&2
                continue
        fi
        result=$(awk "BEGIN {printf \"%.4f\", 0.5 * $x * $x}")
        echo "계산된 y: $result"
done
