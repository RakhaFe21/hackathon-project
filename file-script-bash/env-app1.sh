#!/bin/bash

cont_count=$1
echo "membuat $cont_count container..."
sleep 1;
for i in "seq $cont_count"
do
        echo "=========================="
        echo "membuat go1$i container..."
        sleep 1
        docker run -d -p 3000:3000 --name go1$i --network go-network rakhafe/go1
done

