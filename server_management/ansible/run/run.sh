### SSH 관련 
scp semsekey.pem semsekey.pem ubuntu@43.201.141.125 /ansible/etc/semsekey.pem


### Ansible Ad hoc
ansible all -i ./inventory/hosts.yaml -m ping


### 전체 서버 배포
# 자바 & 도커 설치
ansible-playbook -i ./inventory/hosts.yaml ./playbook/all/java\&docker.yaml

# 파이썬 설치
ansible-playbook -i ./inventory/hosts.yaml ./playbook/all/python.yaml

# 도커 정상설치 되었는지 확인
ansible all -i ./inventory/hosts.yaml -m command -a "docker --version" -b
# 도커 컨테이너 확인
ansible all -i ./inventory/hosts.yaml -m command -a "docker ps -a" -b

# 도커 네트워크 설치
ansible-playbook -i ./inventory/hosts.yaml ./playbook/all/docker_init.yaml



# 데이터 생성서버 배포
ansible-playbook -i ./inventory/hosts.yaml ./playbook/data_server/datagenerator.yaml