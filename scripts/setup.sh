#!/bin/bash

#create network namespace
ip netns add ns1
ip netns add ns2

#create veth pair
ip link add veth-ns1 type veth peer name veth-ns2
ip link set veth-ns1 netns ns1
ip link set veth-ns2 netns ns2


#Assign IP addresses to veth pairs
ip netns exec ns1 ip addr add 192.168.1.1/24 dev veth-ns1
ip netns exec ns2 ip addr add 192.168.1.2/24 dev veth-ns2

#Bring up the interfaces
ip netns exec ns1 ip link set veth-ns1 up
ip netns exec ns2 ip link set veth-ns2 up



echo "Network namespace created successfully"
echo "Namespace ns1 IP: 192.168.1.1, Namespace ns2 IP: 192.168.1.2"

 
#  The above script creates two network namespaces ns1 and ns2 and connects them using a veth pair. 
#  To run the script, execute the following command: 
#  $ sudo bash setup.sh
 
#  To verify the network namespaces, execute the following command: 
#  $ ip netns list
 
#  The output should be similar to the following: 
#  ns1
#  ns2
