### SSH 관련 
scp semsekey.pem semsekey.pem ubuntu@43.201.141.125 /ansible/etc/semsekey.pem
chmod 600 semsekey.pem
sudo chmod 777 /etc/ansible

### Ansible Ad hoc
# 핑 확인
ansible all -i ./inventory/hosts.yaml -m ping
ansible all -i ./inventory/hosts2.yaml -m ping


### 전체 서버
# 서버 public ip 확인
curl -s http://169.254.169.254/latest/meta-data/public-ipv4
# 서버 private ip 확인
curl -s http://169.254.169.254/latest/meta-data/local-ipv4

# 자바 & 도커 & 환경설정
ansible-playbook -i ./inventory/hosts.yaml ./playbook/all/init.yaml
# 도커 정상설치 되었는지 확인
ansible all -i ./inventory/hosts.yaml -m command -a "docker --version" -b
# 도커 컨테이너 확인
ansible all -i ./inventory/hosts.yaml -m command -a "docker ps" -b


### 데이터 서버
# 데이터 생성서버 배포
ansible-playbook -i ./inventory/hosts.yaml ./playbook/data_server/datagenerator.yaml
# 데이터 생성서버 인플럭스 설치
ansible-playbook -i ./inventory/hosts.yaml ./playbook/data_server/data_generator_influx.yaml
# 데이터 생성서버 인플럭스 설치
ansible-playbook -i ./inventory/hosts.yaml ./playbook/data_server/data_generator_secret.yaml


### 카프카 서버
ansible-playbook -i ./inventory/hosts.yaml ./playbook/kafka_server/kafka.yaml


### 메인 서버
ansible-playbook -i ./inventory/hosts2.yaml ./playbook/main_server/data_division_playbook.yaml
ansible-playbook -i ./inventory/hosts2.yaml ./playbook/main_server/react_playbook.yaml