#!/bin/bash

pidwait () {
  kill -0 $1
  x=$?
  while(( $x==0 ))
  do
    sleep 1
    kill -0 $1
    x=$?
  done
  echo "Finish!"
}

echo "Start of pidwait..."
sleep_amount=10
sleep ${sleep_amount} &
pid=$(pgrep -f "sleep ${sleep_amount}")
pidwait ${pid}
echo "End of pidwait..."
