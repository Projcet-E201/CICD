# https://soy3on.tistory.com/m/200


# 0. git clone 받기
git clone -b develop https://lab.ssafy.com/s08-final/S08P31E201.git

# 1. 부모 레포지토리에 넣어줄 자식 레포지토리 추가
# git remote add [지정한 remote 이름] [git repository 주소]
git remote add Front https://github.com/Projcet-E201/Front.git
git remote add DataDivision https://github.com/Projcet-E201/DataDivision.git
git remote add DataGenerator https://github.com/Projcet-E201/DataGenerator.git
git remote add Api https://github.com/Projcet-E201/Api.git

# 2. 정상적으로 등록되었는지 확인
git remote -v


# 3. remote 이름을 확인후 부모 repository에 subtree로 추가
# git subtree add --prefix=[부모 repository에 등록할 이름] [자식 remote 이름] [원격 브랜치 이름]
git subtree add --prefix=Front Front main
git subtree add --prefix=DataDivision DataDivision main
git subtree add --prefix=DataGenerator DataGenerator main
git subtree add --prefix=Api Api main


# 4. 원하는 subtree를 모두 추가했다면 push
git push