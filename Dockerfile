FROM ubuntu

#서버 접속시 기본으로 설정되는 작업 폴더를 지정(설정한 폴더가 실제 없더라도 자동으로 생성된다)  
WORKDIR /home/project

#서버에 복사할 프로젝트 파일
COPY Back/BE /home/project/BE
COPY Front/FE /home/project/FE
COPY setting.sh /home/project/

#RUN은 이미지가 만들어질때 실행되는 명령
#복사한 파일에 실행권한을 준다
RUN chmod 755 /home/project/BE
RUN chmod 755 /home/project/FE
RUN chmod +x /home/project/setting.sh


#Spring boot package install & build(gradle install) & nginx & mysql-server install
#리눅스에서 필요한 패키지 설치 & 자바 설치 &  nginx 웹서버 설치 & mysql 서버 설치
RUN apt update && apt install -y vim openssh-server curl net-tools wget unzip lsof \
    openjdk-8-jdk nginx mysql-server
#스프링부트 프로젝트를 빌드하기위한 gradle 설치 & 프로젝트 빌드
RUN wget https://services.gradle.org/distributions/gradle-4.10.2-bin.zip \
    && mkdir /opt/gradle \
    && unzip -d /opt/gradle gradle-4.10.2-bin.zip \
    && export PATH=$PATH:/opt/gradle/gradle-4.10.2/bin \
    && echo 'export PATH=$PATH:/opt/gradle/gradle-4.10.2/bin' >> ~/.bashrc
RUN cd /home/project/BE && chmod +x gradlew && ./gradlew build

#mysql 설정
RUN mkdir -p /nonexistent
RUN chown mysql:mysql /nonexistent

#컨테이너가 생성되고 mysql이 처음 실행이될때 mysql에 만들어질 데이터베이스와 테이블 설정(init.sql은 컨테이너가 만들어질때 한번만 실행된다)
COPY init.sql /docker-entrypoint-initdb.d/
COPY my.cnf /etc/mysql/my.cnf
#mysql에서 데이터베이스에 연결하기위한 환경변수 설정
ENV MYSQL_ROOT_PASSWORD=1234
ENV MYSQL_DATABASE=board_back
ENV MYSQL_USER=root
ENV MYSQL_PASSWORD=1234
ENV MYSQL_PORT=3306

EXPOSE 3306
#mysql을 실행할때 실행될 쿼리파일
RUN service mysql start && mysql -u root -p${MYSQL_ROOT_PASSWORD} -h localhost < /docker-entrypoint-initdb.d/init.sql

#리액트 프로젝트를 nginx에 설정한 파일
COPY default /etc/nginx/sites-available/default

#react package install & node.js install
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt install -y nodejs
RUN cd /home/project/FE \
    && npm install react-scripts --save \
    && npm install	    

#react build
RUN cd /home/project/FE \
    && npm run build

ENTRYPOINT ["./setting.sh"]
