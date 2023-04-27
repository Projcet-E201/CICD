#!/bin/bash
sudo apt update
sudo apt install openjdk-11-jre -y
java -version

curl -fsSL https://pkg.jenkins.io/debian-stack/jenkins.io.key | sudo tee /usr/share/keyring/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyring/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt install ca-certificates

sudo apt update
sudo apt install jenkins -y

sudo systemctl start jenkins
sudo systemctl enable jenkins

# Install Ansible
sudo apt update
sudo apt install software-properties-common -y
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt install ansible -y