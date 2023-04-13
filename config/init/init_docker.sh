# https://velog.io/@dgh03207/AWS-EC2%EC%97%90-Docker-%EC%84%A4%EC%B9%98


# 0. 사전작업
# 패키징 툴(pat-get) 업데이트
# 필수 패키지 설치
sudo apt update
sudo apt upgrade

# 1. 도커 설치준비
# Docker의 GPC Key 인증
# Docker Repository 등록
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# 2. 도커 CE 설치
sudo apt-get install docker-ce

# 3. 도커 일반 사용자계정 작업
sudo usermod -aG docker $USER
# 우분투 재실행
sudo systemctl reboot 

# 4. 버전 확인
docker -v


---
# 1. 도커 컴포즈 설치
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# 2. 도커 컴포즈 버전확인
docker-compose -v