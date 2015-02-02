FROM ubuntu
MAINTAINER krishna.muthyala

ENV http_proxy "http://113.128.176.118:3128"
ENV https_proxy "http://113.128.176.118:3128"
# make sure the package repository is up to date
RUN echo "deb http://archive.ubuntu.com/ubuntu trusty main universe" > /etc/apt/sources.list
RUN apt-get update 
RUN apt-get -y install software-properties-common 
RUN apt-get update && apt-get -y upgrade
RUN echo "JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64" >> /etc/environment
RUN apt-get -y wget
RUN wget http://mirror.atlanticmetro.net/apache/tomcat/tomcat-7/v7.0.57/bin/apache-tomcat-7.0.57.tar.gz
RUN tar xzvf  apache-tomcat-7.0.57.tar.gz
RUN mkdir -p /usr/local/tomcat7
RUN mv apache-tomcat-7.0.57 /usr/local/tomcat7
ADD /scripts/tomcat /etc/init.d/tomcat
RUN chmod 755 /etc/init.d/tomcat

ADD dist/hello-world.war /usr/local/tomcat7/webapps/
ADD scripts/tomcat-users.xml /usr/local/tomcat7/conf/



RUN apt-get -y install libtomcat7-java
RUN apt-get -y install tomcat7
RUN echo "JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64/" >> /etc/default/tomcat7
EXPOSE 8080
CMD service tomcat7 start && tail -f /var/lib/tomcat7/logs/catalina.out

