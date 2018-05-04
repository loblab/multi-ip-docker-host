#!/bin/bash
set -e

# Modify following parameters
NET=10.7.3
TARGET=$NET.16
NIC=enp4s0

IP1=$NET.201
IP2=$NET.202

function setup() {
    echo "Setup NIC & servers..."
    ip addr | grep $IP1 || sudo ip addr add $IP1/24 dev $NIC
    ip addr | grep $IP2 || sudo ip addr add $IP2/24 dev $NIC
    docker-compose up -d
}

function wget_test() {
    wget -q -O /dev/null http://$1/ && echo "Connect $1: PASS" || echo "Connect $1: FAIL"
}

function test1() {
    echo "Connect server port via different IP..."
    wget_test $IP1:801
    wget_test $IP2:801
    wget_test $IP1:802
    wget_test $IP2:802
}

function test2() {
    echo "ping from different NIC/server..."
    echo "Please capture ICMP packets on $TARGET"
    set +e
    set -x
    ping -c 1 -I $IP1 $TARGET
    ping -c 1 -I $IP2 $TARGET
    docker exec server1 ping -c 1 $TARGET
    docker exec server2 ping -c 1 $TARGET
}

setup
test1
test2
