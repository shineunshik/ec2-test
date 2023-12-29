#!/bin/bash

#nginx 재시작
service nginx restart

#spring project start
cd /home/project/BE/build/libs
chmod +x springboot-back-project-1.0-SNAPSHOT.jar
#아래 명령어는 로그를 직접 설정한 파일에저장하기
#nohup java -jar springboot-back-project-1.0-SNAPSHOT.jar > output.log 2>&1 &

#아래 명령어는 jar파일과 같은 경로에 로그파일이 생성됨
nohup java -jar springboot-back-project-1.0-SNAPSHOT.jar &
#mysql background  start
mysqld &
#sleep infinity 는 프로세스가 대기 상태로 진입하게 된다
sleep infinity
#아래 명령어도 프로세스를 무한히 대기 상태로 진입하게 되지만 부팅시 이전에 이미 실행중이어서 퉁돌이 난다
#하지만 컨테이너를 만들때 --restart awalys를 설정하면 아래 명령어도 문제가 없다
#tail -f /dev/null
