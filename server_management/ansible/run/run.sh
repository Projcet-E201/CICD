### SSH 관련 
scp semsekey.pem semsekey.pem ubuntu@43.201.141.125 /ansible/etc/semsekey.pem
chmod 600 semsekey.pem

### Ansible Ad hoc
# 핑 확인
ansible all -i ./inventory/hosts.yaml -m ping
ansible all -i ./inventory/hosts2.yaml -m ping


### 전체 서버
# 서버 public ip 확인
curl -s http://169.254.169.254/latest/meta-data/public-ipv4
# 서버 private ip 확인
curl -s http://169.254.169.254/latest/meta-data/local-ipv4

# 자바 & 도커 설치
ansible-playbook -i ./inventory/hosts.yaml ./playbook/all/java\&docker.yaml
# 도커 정상설치 되었는지 확인
ansible all -i ./inventory/hosts.yaml -m command -a "docker --version" -b
# 도커 컨테이너 확인
ansible all -i ./inventory/hosts.yaml -m command -a "docker ps" -b


# 파이썬 설치
ansible-playbook -i ./inventory/hosts.yaml ./playbook/all/python.yaml

# 도커 추가설정
ansible-playbook -i ./inventory/hosts.yaml ./playbook/all/docker_init.yaml


### 데이터 서버
# 데이터 생성서버 배포
ansible-playbook -i ./inventory/hosts.yaml ./playbook/data_server/datagenerator.yaml


### 카프카 서버
ansible-playbook -i ./inventory/hosts.yaml ./playbook/kafka_server/kafka.yaml