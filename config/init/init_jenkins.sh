# https://velog.io/@yjj4899/Ubuntu-22.04-Jenkins-%EC%84%A4%EC%B9%98%ED%95%98%EA%B8%B0


# 1. 자바 설치
sudo apt install openjdk-11-jre -y
java -version

# 2. jenkins 실행명령어
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

# 만약 apt 인증예외가 발생한다면 ca-certificates 패키지를 업데이트 한다
# https://hamonikr.org/hamoni_board/106932
sudo apt install ca-certificates

# 3. 업데이트 & 설치
sudo apt update
sudo apt install jenkins -y

# 4. 젠킨스 실행확인
sudo systemctl status jenkins

# 5. 부팅 시 젠킨스 시작되는지 확인
sudo systemctl is-enabled jenkins

# 6. 젠킨스 초기 비밀번호 확인
sudo cat /var/lib/jenkins/secrets/initialAdminPassword


# 젠킨스 재시작
sudo service jenkins restart

# 이후 플러그인 설치가 잘안된다면 아래링크 참조
# https://chomdoo.tistory.com/31