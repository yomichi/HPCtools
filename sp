#!/bin/sh 
set -u -e

threshold=1.0
n=""

if [ $# -ge 1 ];then
    threshold=$1
fi
if [ $# -ge 2 ];then
  n="-n $2"
fi

ncol=`tput cols`

for node in "sekirei1" "sekirei2" ;do
    echo "${node}:"
    ps x o user,pid,ppid,pcpu,pmem,tt,stat,start,atime,args | head -n1
    ssh $node ps ax o user,pid,ppid,pcpu,pmem,tt,stat,start,atime,args | awk --assign th=$threshold '$1 ~ /([krim][0-9]{6}|ark|sgi)/ && $4 > th {sub(/[ \t\r\n]+$/, "", $0); print}' | sort -nk 4,4 | tail $n | gawk --assign ncol=$ncol '{print substr($0,1,2*ncol)}'
    echo ""
done
