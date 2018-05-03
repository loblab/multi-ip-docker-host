# Reproduce the bug of host_binding_ipv4 in multiple IP host with 1 NIC.

See also: [Wrong source IP from container with host_binding_ipv4 in a 2 IP host with 1 NIC](https://github.com/docker/for-linux/issues/296)

- Platform: docker-ce 18.03 at Linux (Debian 9.x, Ubuntu 16.04)
- Created: 5/3/2018
- Author: loblab

## Usage

1. Prepare a Linux HOST, and another PC/Mac TARGET for testing.
2. Have docker-ce, docker-compose installed on HOST
3. Modify the ip address, NIC etc in test.sh and docker-compose.yml as your environment
4. Prepare to capture ICMP packets on TARGET
5. Run ./test.sh on HOST

## Result of test1

```
Connect 10.7.3.201:801: PASS
Connect 10.7.3.202:801: FAIL
Connect 10.7.3.201:802: FAIL
Connect 10.7.3.202:802: PASS
```

It is as expected. We can only access server1 service via IP1, access server2 service via IP2.

## Result of test2

See screenshot below.

- TARGET: 10.7.3.16
- HOST/IP0: 10.7.3.12
- HOST/IP1: 10.7.3.201
- HOST/IP2: 10.7.3.202

![ping packets](https://raw.githubusercontent.com/loblab/multi-ip-docker-host/master/ping-packets.png)

Check the source IP of the 4 cases:

- ping -I IP1 TARGET ==> IP1, correct
- ping -I IP2 TARGET ==> IP2, correct
- docker exec server1 ping TARGET ==> IP0, not as expected (expect IP1)
- docker exec server2 ping TARGET ==> IP0, not as expected (expect IP2)

