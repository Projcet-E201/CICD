# https://jammdev.tistory.com/111

# 만약 pull이 받아지지 않는다면 git remote -v 명령어로 연결되어있는지 확인
# Front, Back, Data, CICD  pull하고 push하기
git subtree pull --prefix=Front Front main
git subtree pull --prefix=Back Back main
git subtree pull --prefix=Data Data main
git subtree pull --prefix=CICD CICD main
git push
