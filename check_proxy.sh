#!/bin/bash

port=9000
while read proxy; do
  killall -s SIGKILL socat >/dev/null 2>&1
  sleep 1

  port=$((port+1))
  socat TCP-LISTEN:$port OPENSSL:$proxy:443 &
  sleep 1

  r=$(CURL_CA_BUNDLE=signal_CA.crt curl -s -m 10 https://chat.signal.org:$port --resolve chat.signal.org:$port:127.0.0.1)
  t=$(echo $r | grep "HTTP 404 Not Found")
  if [ "$t" == "" ]; then
     res="❌"
  else
     res="✅"
  fi

  echo "$proxy $res"
  echo "------------------"
  echo "$proxy $res" >> results.txt
done < proxies.txt
