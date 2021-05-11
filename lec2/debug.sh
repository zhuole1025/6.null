#!/usr/bin/env bash

times=0
((x=0))
while [[ $x -ne 1 ]]
do
    ./bug.sh 
    x=$?  
    ((times++))
done
echo "total run times: $times"