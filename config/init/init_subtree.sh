# https://soy3on.tistory.com/m/200


# 0. git clone 받기
git clone -b develpo https://lab.ssafy.com/s08-bigdata-recom-sub2/S08P22E105.git

# 1. 부모 레포지토리에 넣어줄 자식 레포지토리 추가
# git remote add [지정한 remote 이름] [git repository 주소]
# Front, Back, Data, CICD
git remote add Front https://github.com/ProjectTeam-Test/Front.git
git remote add Back https://github.com/ProjectTeam-Test/Back.git
git remote add Data https://github.com/ProjectTeam-Test/Data.git
git remote add CICD https://github.com/ProjectTeam-Test/CICD.git
git remote add Auth https://github.com/ProjectTeam-Test/Auth.git

# 2. 정상적으로 등록되었는지 확인
git remote -v


# 3. remote 이름을 확인후 부모 repository에 subtree로 추가
git subtree add --prefix=[부모 repository에 등록할 이름] [자식 remote 이름] [원격 브랜치 이름]
# Front, Back, Data, CICD
git subtree add --prefix=Front Front main
git subtree add --prefix=Back Back main
git subtree add --prefix=Data Data main
git subtree add --prefix=CICD CICD main
git subtree add --prefix=Auth Auth main


# 4. 원하는 subtree를 모두 추가했다면 push
git push