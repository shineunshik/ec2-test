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
tail -f /dev/null
