#!/bin/bash

cont_count=$1
echo "membuat $cont_count container..."
sleep 1;
for i in "seq $cont_count"
do
        echo "=========================="
        echo "membuat go2$i container..."
        sleep 1
        docker run -d -p 3001:3001 --name go2$i --network go-network rakhafe/go2
done