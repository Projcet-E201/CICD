#!/bin/bash

# 1. 자바 설치
sudo apt update
sudo apt install openjdk-11-jre -y
java -version

# 2. Jenkins 저장소 Key 다운로드
wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key | sudo apt-key add -

# 3. sources.list 에 추가
echo deb http://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list

# 4. 키 등록
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys FCEF32E745F2C3D5

# 5. 업데이트 & 설치
sudo apt update
sudo apt install jenkins -y

sudo systemctl start jenkins
sudo systemctl enable jenkins

# Install Ansible
sudo apt install ansible
ansible --version