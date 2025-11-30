#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 2 ]; then
	echo "사용법: $0 숫자1 숫자2" >&2
	exit 1
fi

num1=$1
num2=$2

if ! [[ "$num1" =~ ^-?[0-9]+$ ]] || ! [[ "$num2" =~ ^-?[0-9]+$ ]]; then
	echo "오류: 정수 숫자 두 개를 입력하세요." >&2
	exit 1
fi

echo "입력된 두 숫자: $num1, $num2"

sum=$((num1 + num2))
echo "합 = $sum"

sub=$((num1 - num2))
echo "차 = $sub"

pro=$((num1 * num2))
echo "곱 = $pro"

if [ "$num2" -eq 0 ]; then
	echo "몫 = 정의되지 않음 (0으로 나눌 수 없음)"
else
	# 정수 몫 출력
	quo=$((num1 / num2))
	echo "몫 = $quo"
fi
