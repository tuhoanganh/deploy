#!/bin/bash
# bachkhoabk47@gmail.com

# OpenCPS is the open source Core Public Services software
# Copyright (C) 2016-present OpenCPS community

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU Affero General Public License for more details.
# You should have received a copy of the GNU Affero General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.

############## Installing for Centos 7, Ubuntu & Fedora #####################################

DIR="`pwd`"
DIR_CURR=$DIR/docker-compose-allintwo

############### Installing Docker on Centos, Ubuntu, Fedora ########################
# Update installed package
#M_PLATFORM=`python -mplatform |grep -Eo "Ubuntu"`

M_PLATFORM_UBUNTU=`python -mplatform |grep -Eo "Ubuntu"`
M_PLATFORM_CENTOS=`python -mplatform |grep -Eo "centos"`
M_PLATFORM_FEDORA=`python -mplatform |grep -Eo "fedora"`
echo $M_PLATFORM_CENTOS

if [[ $EUID -ne 0 ]]; then
 echo "You are not running with root permission, so that why should chage to root for executing to install something"
 if [[ $M_PLATFORM_UBUNTU == "Ubuntu" ]]; then
  echo "Type: sudo -s before running script"
  sudo -s
 elif [ $M_PLATFORM_CENTOS == "centos" ]; then
  echo "Type: su - before running script"
  exit;
 elif [ $M_PLATFORM_FEDORA == "fedora" ]; then
  echo "Type: su - before running script"
  exit;
 else
  echo "This could not ecognize any distro of Linux, please check it again"
 fi 
else
 echo "Good! You are running with root permission!"
fi

function app_update {
 if [[ $M_PLATFORM_UBUNTU == "Ubuntu" ]]; then
  apt-get update -y
 elif [ $M_PLATFORM_CENTOS == "centos" ]; then
  yum update -y
 elif [ $M_PLATFORM_FEDORA == "fedora" ]; then
  yum update -y
 else
  echo "This could not ecognize any distro of Linux, please check it again"
 fi
}

function install_svn {
 if [[ $M_PLATFORM_UBUNTU == "Ubuntu" ]]; then
  if which svn >/dev/null; then
    echo "svn installed, so next to install other app"
  else
    apt-get install subversion -y
  fi
 elif [[ $M_PLATFORM_CENTOS == "centos" ]]; then
  if which svn >/dev/null; then
    echo "svn installed, so next to install other app"
  else
    yum install svn -y
  fi
 elif [[ $M_PLATFORM_FEDORA == "fedora" ]]; then
  if which svn >/dev/null; then
    echo "svn installed, so next to install other app"
  else
    yum install subversion -y
  fi
 else
  echo "This could not ecognize any distro of Linux, please check it again"
 fi
}

function chkconfig_docker {
 if [[ $M_PLATFORM_UBUNTU == "Ubuntu" ]]; then
  echo "Version Ubuntu > 14.10, this just needs"
 elif [[ $M_PLATFORM_CENTOS == "centos" ]]; then
  chkconfig docker on
 elif [[ M_PLATFORM_FEDORA == "fedora" ]]; then
  chkconfig docker on
 else 
  echo "This could not ecognize any distro of Linux, please check it again"
 fi
}

function install_docker {
 if which docker >/dev/null; then
    echo "docker installed, so go to next step"
 else
    curl -fsSL https://get.docker.com/ | sh
    service docker start
 fi

 if which docker-compose >/dev/null; then
    echo "docker-compose installed, so go to next step"
 else
    ############## Installing Docker-compose on Centos 7, Ubuntu, Fedora ###############
    # Download and run script for installing docker-compose
    wget https://github.com/docker/compose/releases/download/1.7.1/docker-compose-`uname -s`-`uname -m` -O /usr/local/bin/docker-compose
    # Chown permission
    chmod 755 /usr/local/bin/docker-compose
 fi

}

function check_distro {
 app_update
 
 apt-get install curl -y
 install_svn
 install_docker
 chkconfig_docker

}
check_distro

############## Installing Docker-compose on Centos 7, Ubuntu, Fedora ###############
# Download and run script for installing docker-compose
#sudo wget https://github.com/docker/compose/releases/download/1.7.1/docker-compose-`uname -s`-`uname -m` -O /usr/local/bin/docker-compose
# Chown permission
#sudo chmod +x /usr/local/bin/docker-compose


##########################################################################

######################## DEPLOYING OPENCPS APPLICATION ##################
#sudo svn export https://github.com/VietOpenCPS/deploy.git/trunk/Dockerize-OpenCPS/all-in-one-container/docker-compose

echo $DIR_CURR

if [ -d "$DIR_CURR" ]; then
  
  echo -n "Folder exists. Please type y for overried folder -- "
  echo -n " y/n: "
  read text
  echo "You entered : $text"
  
  #Do whatever you want

  if [ $text == "y" ]; then
    svn export https://github.com/VietOpenCPS/deploy.git/trunk/opencps-dockerize/dockerize-all-in-two-containers/docker-compose-allintwo --force
    sh -c `cd $DIR_CURR && docker-compose -f docker-compose.yml up -d`
    echo "Done! You can open browser with the address: localhost:8080 for testing application. Thanks"
  else
    echo "You've exited running script"
    exit;
  fi 
else
  svn export https://github.com/VietOpenCPS/deploy/trunk/opencps-dockerize/dockerize-all-in-two-containers/docker-compose-allintwo
  sh -c `cd $DIR_CURR && docker-compose -f docker-compose.yml up -d`
  #SERVER=localhost
  #PORT=3306
  #`nc -z -v -w5 $SERVER $PORT`
  #result1=$?
  #if [  "$result1" != 0 ]; then
  #  echo  'port 3306 is closed'
  #else
  #  echo 'port 3306 is open'
   # docker start dockercomposeallintwo_liferay_1
  #fi
  
fi
sleep 240
name='dockercomposeallintwo_liferay_1'
echo $name
container_id=`docker ps  --filter="name=$name" -q`
echo $container_id 
docker stop $container_id
sleep 5
docker start $container_id
echo "Done! You can open browser with the address: localhost:8080 for testing application. Thanks"
