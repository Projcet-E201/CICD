# 도커 설치
sudo apt update

sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common jq

# Add Docker repository
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Install Docker
sudo apt-get update
sudo apt-get install -y --no-install-recommends docker-ce
sudo usermod -aG docker $USER

# 도커 서비스 시작
sudo systemctl start docker
sudo systemctl enable docker


# 도커 컴포즈 설치
VERSION=$(curl --silent https://api.github.com/repos/docker/compose/releases/latest | jq .name -r)
sudo curl -L "https://github.com/docker/compose/releases/download/${VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# portainer로 관리하기 위해 2375 오픈
sudo bash -c 'echo -e "{\n  \"hosts\": [\"unix:///var/run/docker.sock\", \"tcp://0.0.0.0:2375\"]\n}" > /etc/docker/daemon.json'
sudo systemctl restart docker

# 자바 11 설치
sudo apt-get install -y openjdk-11-jdk