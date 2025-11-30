#!/bin/bash
# src/ex3-4.sh


scores=()


show_menu() {
    echo -e "\n=============================="
    echo "1) 과목 성적 추가"
    echo "2) 입력된 모든 점수 보기"
    echo "3) 평균 점수 확인"
    echo "4) 평균 등급 (GPA) 변환"
    echo "5) 종료"
    echo "=============================="
}


add_score() {
    read -p "추가할 과목 점수 (0-100)를 입력하세요: " new_score
    if [[ "$new_score" =~ ^[0-9]+$ ]] && [ $new_score -ge 0 ] && [ $new_score -le 100 ]; then
        scores+=("$new_score")
        echo "✅ 점수 $new_score가 추가되었습니다."
    else
        echo "❌ 오류: 0-100 사이의 유효한 점수를 입력하세요."
    fi
}


view_scores() {
    if [ ${#scores[@]} -eq 0 ]; then
        echo "⚠️ 입력된 점수가 없습니다."
    else
        echo "--- 입력된 모든 점수 (${#scores[@]}개) ---"
        printf "%s\n" "${scores[@]}"
    fi
}

calculate_average() {
    if [ ${#scores[@]} -eq 0 ]; then
        echo "계산할 점수가 없습니다." >&2
        return 1 
    fi

    local total=0
    for score in "${scores[@]}"; do
        if ! [[ "$score" =~ ^[0-9]+$ ]]; then
            echo "오류: 잘못된 점수 값: $score" >&2
            return 1
        fi
        total=$(( total + score ))
    done


    local avg
    avg=$(awk "BEGIN {printf \"%.2f\", $total / ${#scores[@]}}")
    echo "$avg"
}


convert_gpa() {
    local avg_score
    if ! avg_score=$(calculate_average); then
        return 0
    fi

    local avg_int
    avg_int=$(printf "%d" "${avg_score%.*}")

    local gpa
    if [ "$avg_int" -ge 90 ]; then
        gpa="A"
    else
        gpa="B"
    fi

    echo "평균 점수 ($avg_score)에 대한 평균 등급(GPA): $gpa"
}

while true; do
    show_menu
    read -p "선택 (1-5): " choice

    case $choice in
        1) add_score ;;
        2) view_scores ;;
        3) calculate_average ;;
        4) convert_gpa ;;
        5) echo "프로그램을 종료합니다."; break ;;
        *) echo "잘못된 선택입니다. 1에서 5 사이의 숫자를 입력하세요." ;;
    esac
done
