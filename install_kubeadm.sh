#!/bin/bash
# /etc/hosts
cat <<EOF | sudo tee /etc/hosts
54.224.101.176 Master
44.212.4.214 Worker-1
52.70.219.249 Worker-2
EOF

# SELinux
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

# kernel modules
modprobe overlay
modprobe br_netfilter
cat > /etc/modules-load.d/k8s.conf << EOF
overlay
br_netfilter
EOF

# systemctl settings
cat > /etc/sysctl.d/k8s.conf << EOF
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system

# swap
sudo swapoff -a
sed -e '/swap/s/^/#/g' -i /etc/fstab


# containerd
dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
dnf makecache
dnf install -y containerd.io
sudo mkdir /etc/containerd
sudo sh -c "containerd config default > /etc/containerd/config.toml"
sudo sed -i 's/            SystemdCgroup = false/            SystemdCgroup = true/' /etc/containerd/config.toml
systemctl enable --now containerd.service
sudo systemctl restart containerd.service

# kubernetes components
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.28/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.28/rpm/repodata/repomd.xml.key
exclude=kubelet kubeadm kubectl cri-tools kubernetes-cni
EOF
dnf makecache

# install tools
sudo yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
systemctl enable --now kubelet.service
sudo kubeadm config images pull
