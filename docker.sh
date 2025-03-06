#!/bin/bash

USER_ID=$(id -u)

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo "$2 is FAILED"
        exit 1
    else
        echo "$2 is SUCCESS"
     fi
}

CHECK(){
    if [ $USER_ID -ne 0 ]
    then 
        echo "Please Run this scirpt with ROOT previleges"
        exit 1
    fi
}
CHECK


#install docker
sudo dnf -y install dnf-plugins-core
VALIDATE $? "Installing Docker plugins"
 
sudo dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo
VALIDATE $? "Installing Docker Repo"

sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
VALIDATE $? "Installing Docker Compose Plugins"

sudo systemctl start docker
VALIDATE $? "Start Docker"

sudo usermod -aG docker ec2-user
VALIDATE $? "User added in Docker group"

sudo docker run hello-world
VALIDATE $? "Response from Docker"

sudo docker --version
VALIDATE $? "Displaying Docker Version"




#Resize Disk
sudo lsblk

sudo growpart /dev/nvme0n1 4
VALIDATE $? "Disk Partition"

sudo lvextend -l +50%FREE /dev/RootVG/rootVol 


sudo lvextend -l +50%FREE /dev/RootVG/varVol
sudo xfs_growfs /
VALIDATE $? "Resize of RootVol"

sudo xfs_growfs /var
VALIDATE $? "Resize of VarVol"





#install kubectl

sudo curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.31.3/2024-12-12/bin/linux/amd64/kubectl

sudo chmod +x ./kubectl

sudo mv kubectl /usr/local/bin/kubcetl

sudo kubectl version --client
VALIDATE $? "Installion of Kubectl"

#install eksctl
# for ARM systems, set ARCH to: `arm64`, `armv6` or `armv7`
ARCH=amd64
PLATFORM=$(uname -s)_$ARCH

sudo curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$PLATFORM.tar.gz"


sudo tar -xzf eksctl_$PLATFORM.tar.gz -C /tmp && rm eksctl_$PLATFORM.tar.gz

sudo mv /tmp/eksctl /usr/local/bin

sudo eksctl version
VALIDATE $? "Installation of Eksctl"

df -hT
VALIDATE $? "Volume Resize"


echo "Exit and Login Agian will work Docker commands. Thanks"

echo "Note: aws configure to authenticate with AWS"