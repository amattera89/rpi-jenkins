#!/bin/bash
java -Duser.home=$JENKINS_HOME -jar /usr/local/jenkins.war &&
tail -f /dev/null