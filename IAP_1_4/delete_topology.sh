# delete open flow controll
ovs-vsctl del-controller s1
ovs-vsctl del-controller s2
ovs-vsctl del-controller s3

ip link del s1-eth1 
ip link del s2-eth1

ip link del s1-eth2 
ip link del s1-eth3 
ip link del s2-eth3 

# delete ports
ovs-vsctl --if-exists del-port s3 s3-eth3
ovs-vsctl --if-exists del-port s3 s3-eth2
ovs-vsctl --if-exists del-port s3 s3-eth1

ovs-vsctl --if-exists del-port s2 s2-eth3
ovs-vsctl --if-exists del-port s2 s2-eth2
ovs-vsctl --if-exists del-port s2 s2-eth1

ovs-vsctl --if-exists del-port s1 s1-eth3
ovs-vsctl --if-exists del-port s1 s1-eth2
ovs-vsctl --if-exists del-port s1 s1-eth1




# delete switches
ovs-vsctl --if-exists del-br s1
ovs-vsctl --if-exists del-br s2

ovs-vsctl --if-exists del-br s3


# delete hosts
ip netns del h1
ip netns del h2

