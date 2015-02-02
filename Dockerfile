FROM ubuntu
MAINTAINER krishna.muthyala
ENV DEBIAN_FRONTEND noninteractive
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
ENV http_proxy http://113.128.176.118:3128
ENV https_proxy http://113.128.176.118:3128
# make sure the package repository is up to date
RUN echo "deb http://archive.ubuntu.com/ubuntu trusty main universe" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get -y install software-properties-common
RUN apt-get update && apt-get -y upgrade

RUN add-apt-repository ppa:webupd8team/java -y
#install oracle java
RUN apt-get update -y
RUN echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN  apt-get install oracle-java7-installer --force-yes -y  && apt-get clean

RUN update-alternatives --display java

#setup java classpath

RUN echo "JAVA_HOME=/usr/lib/jvm/java-7-oracle" >> /etc/environment

RUN echo "http_proxy=http://irvproxy.verizon.com:80/" >> /etc/environment
RUN echo "https_proxy=http://irvproxy.verizon.com:80/" >> /etc/environment

RUN apt-get -y install wget
RUN wget "http://mirror.atlanticmetro.net/apache/tomcat/tomcat-7/v7.0.57/bin/apache-tomcat-7.0.57.tar.gz"
RUN tar xzvf  apache-tomcat-7.0.57.tar.gz
RUN mv apache-tomcat-7.0.57 /usr/local/
ENV CATALINA_HOME /usr/local/tomcat7
ENV PATH $CATALINA_HOME/bin:$PATH

RUN mv /usr/local/apache-tomcat-7.0.57 /usr/local/tomcat7
ADD /scripts/tomcat /etc/init.d/tomcat
RUN chmod 755 /etc/init.d/tomcat

ADD dist/hello-world.war /usr/local/tomcat7/webapps/
ADD scripts/tomcat-users.xml /usr/local/tomcat7/conf/
ADD scripts/server.xml /usr/local/tomcat7/conf/
EXPOSE 8888
CMD ["catalina.sh", "run"]
