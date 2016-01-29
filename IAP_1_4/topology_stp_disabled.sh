# Creating namespaces
# h1 and h2 will become the virtual hosts
ip netns add h1
ip netns add h2

# Create switch
ovs-vsctl add-br s1
ovs-vsctl set bridge s1 stp_enable=false
ovs-vsctl add-br s2
ovs-vsctl set bridge s2 stp_enable=false
ovs-vsctl add-br s3
ovs-vsctl set bridge s3 stp_enable=false

# Create links 
ip link add h1-eth0 type veth peer name s1-eth1
ip link add h2-eth0 type veth peer name s2-eth1


# Move host ports into namespaces
ip link set h1-eth0 netns h1
ip link set h2-eth0 netns h2


# Connect switch ports to OVS
ovs-vsctl add-port s1 s1-eth1
ovs-vsctl add-port s2 s2-eth1

ovs-vsctl add-port s1 s1-s2
ovs-vsctl add-port s2 s2-s1
ovs-vsctl add-port s1 s1-s3
ovs-vsctl add-port s3 s3-s1
ovs-vsctl add-port s2 s2-s3
ovs-vsctl add-port s3 s3-s2

ovs-vsctl set interface s1-s2 type=patch
ovs-vsctl set interface s2-s1 type=patch
ovs-vsctl set interface s1-s3 type=patch
ovs-vsctl set interface s3-s1 type=patch
ovs-vsctl set interface s2-s3 type=patch
ovs-vsctl set interface s3-s2 type=patch

ovs-vsctl set interface s1-s2 options:peer=s2-s1
ovs-vsctl set interface s2-s1 options:peer=s1-s2
ovs-vsctl set interface s1-s3 options:peer=s3-s1
ovs-vsctl set interface s3-s1 options:peer=s1-s3
ovs-vsctl set interface s2-s3 options:peer=s3-s2
ovs-vsctl set interface s3-s2 options:peer=s2-s3

# Set up OpenFlow controller

ovs-vsctl set-controller s1 tcp:127.0.0.1
ovs-vsctl set-controller s2 tcp:127.0.0.1
ovs-vsctl set-controller s3 tcp:127.0.0.1

# Assigning IP addresses to interfaces and turning on the interfaces
ip netns exec h1 ifconfig h1-eth0 10.0.10.1
ip netns exec h1 ifconfig lo up
ip netns exec h2 ifconfig h2-eth0 10.0.10.2
ip netns exec h2 ifconfig lo up
ifconfig s1-eth1 up
ifconfig s2-eth1 up





# ip netns exec h1 ping -c 10 10.0.10.2
