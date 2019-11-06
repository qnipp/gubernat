#! /bin/sh

# get my IP address
# if I'm using virtual box, my machines have two interfaces:
# enp0s8 as host only network (only reaching from host)
# enp0s3 as NAT interface (only reachable from extern)
# we need the internal interface ;-)
MYIP=`ip route | grep kernel | grep enp0s8 | cut -d " " -f 9`
MYNAME=gubernat.pflaeging.net

echo "My Name:" $MYNAME
echo "My IP:" $MYIP 

# free some ports from firewalld just in case
firewall-cmd --permanent --add-port=8001/tcp
firewall-cmd --permanent --add-port=8443/tcp
firewall-cmd --permanent --add-port=6443/tcp
firewall-cmd --permanent --add-port=10250/tcp
firewall-cmd --reload
# modprobe br_netfilter

cat <<EOF >  /etc/sysctl.d/k8s.conf
net.ipv4.ip_forward=1
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system


echo $MYIP $MYNAME >> /etc/hosts
hostname $MYNAME
echo $MYNAME > /etc/hostname 
