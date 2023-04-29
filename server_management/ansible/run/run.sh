# 자바 & 도커 설치
ansible-playbook -i ./inventory/hosts.yaml ./playbook/all/java\&docker.yaml

# 도커 정상설치 되었는지 확인
ansible all -i ./inventory/hosts.yaml -m command -a "docker --version" -b

# 도커 네트워크 설치
ansible-playbook -i ./inventory/hosts.yaml ./playbook/all/docker_init.yaml



# 데이터 생성서버 배포
ansible-playbook -i ./inventory/hosts.yaml ./playbook/data_server/datagenerator.yaml