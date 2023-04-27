# https://velog.io/@yjj4899/Ubuntu-22.04-Jenkins-%EC%84%A4%EC%B9%98%ED%95%98%EA%B8%B0(17기준)
# https://hyunmin1906.tistory.com/272(11버전)

# 1. 자바 설치
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

# 6. 젠킨스 실행확인
sudo systemctl status jenkins

# 7. 부팅 시 젠킨스 시작되는지 확인
sudo systemctl is-enabled jenkins

# 8. 젠킨스 초기 비밀번호 확인
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
#  70e32d8bb3324ac8af21423e05062a17



# 젠킨스 재시작
sudo service jenkins restart

# 이후 플러그인 설치가 잘안된다면 아래링크 참조
# https://chomdoo.tistory.com/31

# 키 등록에러(15숫자영어에는 본인 값 넣을 것!)
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 5BA31D57EF5975CA
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 5BA31D57EF5975CA