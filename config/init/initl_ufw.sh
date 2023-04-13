# ufw 설치명령
sudo apt-get install ufw

# ufw 상태확인 명령
sudo ufw status verbose
sudo ufw status

# ufw 기본룰 확인
# deny : 들어오는 패킷 거부
# allow : 들어오는 패킷 허가
sudo ufw allow 22 # 22번 ssh포트는 모든 사용자 접근 가능
sudo ufw deny 22 # ssh 포트 아무도 접속불가
sudo ufw allow from <ip> to any port 22 # 22번 포트에서 특정 사용자만 접근이 가능
sudo ufw deny from <ip> to any aport 22 # 기본 정책이 allow라면, 다른 ip에서 22포트는 가능하지만, 특정 ip에서 불가

# ufw 활성화/비활성화 (어떤 설정없이 enable 실행시 오류 발생함!)
sudo ufw enable
sudo ufw disable

sudo ufw allow 22 # ssh (이거하고 활성화해야함!)
sudo ufw enable 
sudo ufw allow 80 # http
sudo ufw allow 443 # https
sudo ufw allow 8080 # https
sudo ufw status

