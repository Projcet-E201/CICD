### SSH 관련 
scp -i semsekey2.pem K8E201T.pem ubuntu@13.209.213.175:/etc/ansible/K8E201T.pem
scp -i semsekey2.pem semsekey2.pem ubuntu@13.209.213.175:/etc/ansible/semsekey2.pem
chmod 600 semsekey2.pem
sudo chmod 777 /etc/ansible

### Ansible Ad hoc
# 핑 확인
ansible all -i ./inventory/hosts.yaml -m ping


### 전체 서버
# 서버 public ip 확인
curl -s http://169.254.169.254/latest/meta-data/public-ipv4
# 서버 private ip 확인
curl -s http://169.254.169.254/latest/meta-data/local-ipv4

# 자바 & 도커 & 환경설정
ansible-playbook -i ./inventory/hosts.yaml ./playbook/all/init.yaml

# cadvisor 추가
ansible-playbook -i ./inventory/hosts.yaml ./playbook/all/cadvisor_playbook.yaml

# 한국시간 변경
ansible-playbook -i ./inventory/hosts.yaml ./playbook/all/time_playbook.yaml

# 도커 정상설치 되었는지 확인
ansible all -i ./inventory/hosts.yaml -m command -a "docker --version" -b
# 도커 컨테이너 확인
ansible all -i ./inventory/hosts.yaml -m command -a "docker ps" -b



### 데이터 서버
# 데이터 생성서버 배포
ansible-playbook -i ./inventory/hosts.yaml ./playbook/data_server/data_generator_playbook.yaml
# 데이터 생성서버 인플럭스 설치
ansible-playbook -i ./inventory/hosts.yaml ./playbook/data_server/data_generator_influx_playbook.yaml
# 데이터 생성서버 시크릿 배포
ansible-playbook -i ./inventory/hosts.yaml ./playbook/data_server/data_generator_secret_playbook.yaml
# 데이터 생성서버 폴더삭제 
ansible-playbook -i ./inventory/hosts.yaml ./playbook/data_server/data_generator_delete_playbook.yaml
# 데이터 디비전서버 배포
ansible-playbook -i ./inventory/hosts.yaml ./playbook/data_division_server/data_division_playbook.yaml


### 카프카 서버
ansible-playbook -i ./inventory/hosts.yaml ./playbook/kafka_server/kafka.yaml


### 메인 서버
ansible-playbook -i ./inventory/hosts.yaml ./playbook/main_server/data_api.yaml
ansible-playbook -i ./inventory/hosts.yaml ./playbook/main_server/react_playbook.yaml