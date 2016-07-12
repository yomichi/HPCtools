#!/bin/sh 
set -u -e

threshold=1.0

if [ $# -ge 1 ];then
    threshold=$1
fi


for node in "sekirei1" "sekirei2" ;do
    echo "${node}:"
    ps aux | head -n 1
    ssh $node ps aux | awk --assign th=$threshold '$1 ~ /([krim][0-9]{6}|ark|sgi)/ && $3 > th {print}' | sort -nk 3,3
    echo ""
done
