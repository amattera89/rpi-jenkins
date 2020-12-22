FROM balenalib/raspberry-pi:buster
MAINTAINER Andrea Mattera 

# GROUP=$(stat -c '%g' /var/run/docker.sock) && \
ENV HOST_DOCKER_GROUP 995
ENV UID 1001
ENV GID 1001
ENV JENKINS_HOME /var/jenkins_home
# Expose the web ui port
EXPOSE 8080 

#Installing deluge headless and relative dependencies
RUN apt-get update && \
apt-get install --no-install-recommends -y  git openjdk-11-jre && \
#install docker
curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh && \
#Clean up.
apt-get clean && rm -rf /var/lib/apt/lists/*
#add scripts 
ADD start.sh /usr/local/start.sh
ADD http://mirrors.jenkins-ci.org/war-stable/latest/jenkins.war /usr/local/jenkins.war
#create folder and user
RUN mkdir -p $JENKINS_HOME && \ 
 groupadd -g $GID jenkins && \ 
 useradd --no-create-home -u $UID -g jenkins -G docker --shell /bin/sh jenkins  && \ 
 chown -R jenkins:jenkins $JENKINS_HOME && \ 
 chmod +x /usr/local/start.sh && \ 
 chmod 644 /usr/local/jenkins.war && \ 
 groupadd -g $HOST_DOCKER_GROUP hostdocker && \ 
 usermod -a -G hostdocker jenkins
WORKDIR $JENKINS_HOME

USER jenkins

CMD ["bash","/usr/local/start.sh"]




