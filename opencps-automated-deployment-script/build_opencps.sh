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

### Color ###

red='\033[0;31m'
green='\033[0;32m'
nc='\033[0m'


#### Prebuild Variables ###
LIFERAY=$(echo 'http://resource.opencps.vn/liferay_opencps.tar.gz')
LIFERAYSDK=$(echo 'http://downloads.sourceforge.net/project/lportal/Liferay%20Portal/6.2.5%20GA6/liferay-plugins-sdk-6.2-ce-ga6-20160112152609836.zip')
#ORACLEJDK=$(echo 'http://download.oracle.com/otn-pub/java/jdk/7u79-b15/jdk-7u79-linux-x64.rpm')
#ORACLEJDKbak=$(echo 'https://www.dropbox.com/s/dehjmpfpo29x4s1/jdk-7u79-linux-x64.rpm')
#OPENCPS=$(echo 'https://github.com/VietOpenCPS/opencps.git')
#ant=$(echo 'https://www.apache.org/dist/ant/binaries/apache-ant-1.9.7-bin.tar.gz')
ORACLEJDK=$(echo 'http://resource.opencps.vn/jdk-7u79-linux-x64.rpm')
ANT=$(echo 'http://resource.opencps.vn/apache-ant-1.9.7-bin.tar.gz')
OPENCPS=$(echo 'http://resource.opencps.vn/rc-1.8-issues-fix.zip')
OPENCPSDB=$(echo 'http://resource.opencps.vn/opencps_db1.8.tar.gz')
LIBRARYSDK=$(echo 'http://resource.opencps.vn/opencps_sdk_lib.tar.gz')
LIBRARYANT=$(echo 'http://resource.opencps.vn/ant_lib.tar.gz')
COMMONPLUGIN=$(echo 'http://resource.opencps.vn/build-common-plugin.xml')
LIBHTTP=$(echo 'http://resource.opencps.vn/httpclient-osgi-4.3.jar')
APISERVICE=$(echo 'http://resource.opencps.vn/ApiServiceLocalServiceBaseImpl.java')

### Build variables ###
OPENCPS_SDK="/opt/opencps"
APP_NAME="opencps-portlet"
APP_WEBINF="$OPENCPS_SDK/portlets/$APP_NAME/docroot/WEB-INF"
APP_BUILDXML="$OPENCPS_SDK/portlets/$APP_NAME/build.xml"
APP_BUILDXML_HOOK="$OPENCPS_SDK/hooks/build.xml"
APP_BUILDXML_THEME="$OPENCPS_SDK/themes/build.xml"

SERVICE_ACCOUNT="src/org/opencps/accountmgt/dao/service.xml"
SERVICE_DATA="src/org/opencps/datamgt/dao/service.xml"
SERVICE_PROCESS="src/org/opencps/processmgt/dao/service.xml"
SERVICE_PAYMENT="src/org/opencps/paymentmgt/dao/service.xml"
SERVICE_SERVICE="src/org/opencps/servicemgt/dao/service.xml"
SERVICE_DOSSIER="src/org/opencps/dossiermgt/dao/service.xml"
SERVICE_USER="src/org/opencps/usermgt/dao/service.xml"
SERVICE_API="src/org/opencps/api/dao/service.xml"
SERVICE_HOLIDAY="src/org/opencps/holidayconfig/dao/service.xml"
SERVICE_STATISTICS="src/org/opencps/statisticsmgt/dao/service.xml"
SERVICE_NOTIFICATION="src/org/opencps/notificationmgt/dao/service.xml"
SERVICE_POSTAL="src/org/opencps/postal/dao/service.xml"

FOLDER="/tmp"

echo ""
echo "================================="
echo "||  Install Required Packages  ||" 
echo "================================="
sudo echo 'nameserver 8.8.8.8' >> /etc/resolv.conf
pkg1=$(rpm -qa| grep wget)
echo -n '[INFO] Checking wget: '
if [[ "$pkg1" == *"wget"*  ]];then
        echo -e "${green}OK${nc}"
else
   echo 'NOT FOUND'
   echo -n '[INFO] Installing wget: '; sudo yum -y install wget >> /dev/null 2>&1;
   pkg1=$(rpm -qa| grep wget)
   if [[ "$pkg1" == *"wget"*  ]];then
        echo -e "${green}DONE${nc}"
   else
        echo -e "${red}[ERROR]${nc} Something wrong with network connection, please resolv the network problem or try again late"
        return;
   fi
fi

pkg2=$(rpm -qa| grep unzip)
echo -n '[INFO] Checking unzip: '
if [[ "$pkg2" == *"unzip"*  ]];then
        echo -e "${green}OK${nc}"
else
   echo 'NOT FOUND'
   echo -n '[INFO] Installing unzip: '; sudo yum -y install unzip >> /dev/null 2>&1;
   pkg2=$(rpm -qa| grep unzip)
   if [[ "$pkg2" == *"unzip"*  ]];then
        echo -e "${green}DONE${nc}"
   else
        echo -e "${red}[ERROR]${nc} Something wrong with network connection, please resolv the network problem or try again late"
        return;
   fi
fi

pkg3=$(rpm -qa| grep git)
echo -n '[INFO] Checking git: '
if [[ "$pkg3" == *"git-"*  ]];then
        echo -e "${green}OK${nc}"
else
   echo 'NOT FOUND'
   echo -n '[INFO] Installing git: '; sudo yum -y install git >> /dev/null 2>&1;
   pkg3=$(rpm -qa| grep git)
   if [[ "$pkg3" == *"git"*  ]];then
        echo -e "${green}DONE${nc}"
   else
        echo -e "${red}[ERROR]${nc} Something wrong with network connection, please resolv the network problem or try again late"
        return;
   fi
fi


echo "============================================="
echo "||  Install Oracle JDK 7u79 and Ant 1.9.7  ||" 
echo "============================================="
ERR=0
cd $FOLDER
download()
{
    local url=$1
    echo -n "    "
    sudo wget --no-check-certificate --progress=dot $url 2>&1 | grep --line-buffered "0K" | \
        sed -u -e "s,\.,,g" | awk '{printf("\b\b\b\b%4s", $2)}'
    echo -ne "\b\b\b\b"
    echo -e " ${green}DONE${nc}"
}


export java_ver=$(java -version 2>&1 >/dev/null | grep 'java version' | awk '{print $3}' |sed 's/"//' |sed 's/"//')
echo -n '[INFO] Checking Java version 1.7.9: '
if [[  $java_ver == *"1.7.0_79"* ]];then
   echo -e "${green}OK${nc}"
else
   echo 'NOT FOUND'
   sudo mkdir /usr/java >> /dev/null 2>&1
   echo -n '[INFO] Downloading Oracle JDK 7u79 -'
   download $ORACLEJDK -P $FOLDER/ 2> $FOLDER/build_opencps.log ||ERR=1
   if [[ $ERR != 1 ]]; then
        export md5check=$(md5sum jdk-7u79-linux-x64.rpm | awk '{print $1}')
        export md5basejdk=$(echo '8486da4cdc4123f5c4f080d279f07712')

        if [[ "$md5check" != "$md5basejdk" ]]; then
                echo -e "${red}[ERROR]${nc} Checksum MD5... Failed!"
                echo -e "${red}[ERROR]${nc} This file is corrupted. Please find another URL."
                sudo rm -rf $FOLDER/jdk-7u79-linux-x64.rpm
                return
        fi

        echo -e "[INFO] Checksum MD5: ${green}OK${nc}"
        sudo rpm -Uvh $FOLDER/jdk-7u79-linux-x64.rpm >> /dev/null 2>&1
        sudo rm -rf $FOLDER/jdk-7u79-linux-x64.rpm
        sudo alternatives --install /usr/bin/java java /usr/java/jdk1.7.0_79/jre/bin/java 2000
        sudo alternatives --install /usr/bin/javaws javaws /usr/java/jdk1.7.0_79/jre/bin/javaws 2000
        sudo alternatives --install /usr/bin/javac javac /usr/java/jdk1.7.0_79/bin/javac 2000
        sudo alternatives --install /usr/bin/jar jar /usr/java/jdk1.7.0_79/bin/jar 2000
        sudo alternatives --set java /usr/java/jdk1.7.0_79/jre/bin/java
        echo '[INFO] Oracle JDK 7u79 has been installed!'
   else
        echo -e "${red}[ERROR]${nc} Download process failed. Check /tmp/build_opencps.log for more information"
        return
   fi
fi

export ant_ver=$(ant -version 2>&1) 
echo -n '[INFO] Checking Ant version 1.9.7: '
if [[  $ant_ver == "Apache Ant"* ]];then
   echo -e "${green}OK${nc}"
else
    echo 'NOT FOUND'
    echo -n '[INFO] Downloading Ant 1.9.7 -'
    download $ANT -P $FOLDER/ 2> $FOLDER/build_opencps.log ||ERR=1
    if [[ $ERR != 1 ]]; then
        export md5check=$(md5sum apache-ant-1.9.7-bin.tar.gz | awk '{print $1}')
        export md5baseant=$(echo 'bc1d9e5fe73eee5c50b26ed411fb0119')
        #export md5baseant=$(wget http://www-us.apache.org/dist/ant/binaries/apache-ant-1.9.7-bin.tar.gz.md5 -O -)
    
        if [[ "$md5check" != "$md5baseant" ]]; then
            echo -e "${red}[ERROR]${nc} Checksum MD5: Failed!"
            echo -e "${red}[ERROR]${nc} This file is corrupted.  Please find another URL."
            sudo rm -rf $FOLDER/apache-ant-1.9.7-bin.tar.gz
            return
        fi
    echo -e "[INFO] Checksum MD5: ${green}OK${nc}"
    echo '[INFO] Ant 1.9.7 has been installed!'
    sudo tar zxvf $FOLDER/apache-ant-*.tar.gz -C /usr/java >> /dev/null 2>&1
    sudo rm -rf $FOLDER/apache-ant-*.tar.gz
    export ANT_HOME=/java/apache-ant-1.9.7
    sudo echo 'export ANT_HOME=/usr/java/apache-ant-1.9.7' >> /etc/profile.d/env.sh
    export PATH=$PATH:$ANT_HOME/bin
    sudo echo 'export PATH=$PATH:$ANT_HOME/bin' >> /etc/profile.d/env.sh
    source /etc/profile.d/env.sh
    else
        echo -e "${red}[ERROR]${nc} Download process failed. Check /tmp/build_opencps.log for more information"
        return
    fi
fi

echo "==============================================================================="
echo "||  Download Liferay Bundle with Jboss 6.2.5GA6 and Liferay Plugins SDK 6.2  ||" 
echo "==============================================================================="
echo -n '[INFO] Downloading Liferay Portal 6.2.5GA6 -'
download $LIFERAY -P $FOLDER/ 2> $FOLDER/build_opencps.log ||ERR=1
if [[ $ERR != 1 ]] ; then
    echo -n '[INFO] Extrating Liferay: '
    tar zxf $FOLDER/liferay_opencps.tar.gz -C /opt >> /dev/null 2>&1
    echo -e "${green}DONE${nc}"
    sudo rm -rf $FOLDER/liferay_opencps.tar.gz
else
    echo -e "${red}[ERROR]${nc} Something wrong here. Please check /tmp/build_opencps.log for more infomation"
    return
fi

echo -n  '[INFO] Downloading Liferay Plugins SDK 6.2 -'
download $LIFERAYSDK -P $FOLDER 2> $FOLDER/build_opencps.log ||ERR=1
if [[ $ERR != 1 ]] ; then
    sudo unzip -q $FOLDER/liferay-plugins-sdk-6.2-ce-ga6*.zip -d /opt/ >> /dev/null 2>&1 && sudo mv /opt/liferay-plugins-sdk-6.2 /opt/sdk
    sudo rm -rf $FOLDER/liferay-plugins-sdk-6.2-ce-ga6*.zip
else
    echo -e "${red}[ERROR]${nc} Something wrong here. Please check /tmp/build_opencps.log for more infomation"
    return
fi

echo "================================================"
echo "||  Downlad library for building file deploy  ||" 
echo "================================================"
export hname=$(hostname)
echo '120.0.0.1  '$hname >> /etc/hosts
echo -n '[INFO] Downloading OpenCPS Library -'
download $LIBRARYSDK -P $FOLDER/ 2> $FOLDER/build_opencps.log ||ERR=1
if [[ $ERR != 1 ]] ; then
    cd $FOLDER
    sudo tar zxvf opencps_sdk_lib.tar.gz > /dev/null 2>&1
    sudo rm -rf $FOLDER/opencps_sdk_lib.tar.gz
else
    echo -e "${red}[ERROR]${nc} Something wrong here. Please check /tmp/build_opencps.log for more infomation"
    return
fi

echo -n '[INFO] Downloading Ant Library -'
download $LIBRARYANT -P $FOLDER/ 2> $FOLDER/build_opencps.log ||ERR=1
if [[ $ERR != 1 ]] ; then
    cd $FOLDER
    sudo tar zxvf ant_lib.tar.gz > /dev/null 2>&1
    sudo rm -rf $FOLDER/ant_lib.tar.gz
else
    echo -e "${red}[ERROR]${nc} Something wrong here. Please check /tmp/build_opencps.log for more infomation"
    return
fi

echo "====================================================================="
echo "||   Download OpenCPS from https://github.com/VietOpenCPS/opencps  ||" 
echo "====================================================================="
source /etc/profile.d/env.sh
echo -n '[INFO] Download Source Code -'
#cd /opt/ && git clone $OPENCPS
#cd /opt/opencps/
#git checkout develop
#git fetch  https://github.com/VietOpenCPS/opencps.git develop
#git merge FETCH_HEAD
download $OPENCPS -P $FOLDER/ 2> $FOLDER/build_opencps.log ||ERR=1
if [[ $ERR != 1 ]] ; then
    cd /opt/
    echo -n '[INFO] Extracting Source Code to /opt/opencps: '
    sudo unzip -q $FOLDER/rc-1.8-issues-fix.zip -d /opt
    sudo mv /opt/opencps-rc-1.8-issues-fix /opt/opencps
    sudo rm -rf $FOLDER/rc-1.8-issues-fix.zip
    echo -e "${green}DONE${nc}"
else
    echo -e "${red}[ERROR]${nc} Something wrong here. Please check /tmp/build_opencps.log for more infomation"
    return
fi

echo "=============================================="
echo "||   Preconfigure for building file deploy  ||" 
echo "=============================================="
echo -n "[INFO] Preconfiguring Source Code:"
cd /opt && sudo \cp -r sdk/* opencps/
sudo rm -rf /opt/sdk
sudo sed -i '341d' $OPENCPS_SDK/build.properties
sudo sed -i '341i ivy.jar.url=https://repository.liferay.com/nexus/content/repositories/liferay-public-snapshots/com/liferay/org.apache.ivy/${ivy.version}/org.apache.ivy-${ivy.version}.jar' $OPENCPS_SDK/build.properties
export user=$(id -u -n)
sudo touch $OPENCPS_SDK/build.${user}.properties
export servertype=$(ls /opt/server/ |grep 'jboss*\|tomcat*')

if [[ "$servertype" == *"jboss"*  ]];then
  sudo echo 'app.server.type = jboss' >> /opt/opencps/build.${user}.properties
  sudo echo 'app.server.parent.dir = /opt/server' >> /opt/opencps/build.${user}.properties
  sudo echo 'app.server.jboss.dir = ${app.server.parent.dir}/'$servertype >> /opt/opencps/build.${user}.properties
  sudo echo 'app.server.jboss.deploy.dir = ${app.server.jboss.dir}/deploy' >> /opt/opencps/build.${user}.properties
  sudo echo 'app.server.jboss.lib.global.dir = ${app.server.jboss.dir}/modules/com/liferay/portal/main' >> /opt/opencps/build.${user}.properties
  sudo echo 'app.server.jboss.portal.dir = ${app.server.jboss.dir}/standalone/deployments/ROOT.war' >> /opt/opencps/build.${user}.properties
  sudo echo 'javac.encoding = UTF-8' >> /opt/opencps/build.${user}.properties
else
  sudo echo 'app.server.type = tomcat' >> /opt/opencps/build.${user}.properties
  sudo echo 'app.server.parent.dir = /opt/server' >> /opt/opencps/build.${user}.properties
  sudo echo 'app.server.tomcat.dir = ${app.server.parent.dir}/'$servertype >> /opt/opencps/build.${user}.properties
  sudo echo 'app.server.tomcat.deploy.dir = ${app.server.tomcat.dir}/webapps' >> /opt/opencps/build.${user}.properties
  sudo echo 'app.server.tomcat.lib.global.dir = ${app.server.tomcat.dir}/lib/ext' >> /opt/opencps/build.${user}.properties
  sudo echo 'app.server.tomcat.portal.dir = ${app.server.tomcat.dir}/webapps/ROOT' >> /opt/opencps/build.${user}.properties
fi

sudo \cp -rf $FOLDER/lib/* $APP_WEBINF/lib/ && sudo rm -rf $FOLDER/lib/
sudo \cp -rf $FOLDER/ant_lib/* $OPENCPS_SDK/lib && sudo rm -rf $FOLDER/ant_lib/
sudo cp -rf $OPENCPS_SDK/lib/ecj.jar $ANT_HOME/lib/ecj.jar
cd $FOLDER && download $COMMONPLUGIN -O $FOLDER && sudo cp -rf $FOLDER/build-common-plugin.xml $OPENCPS_SDK/build-common-plugin.xml && sudo rm -rf $FOLDER/build-common-plugin.xml
sudo sed -i -e "s/ant.build.javac.source=1.6/ant.build.javac.source=1.7/" $OPENCPS_SDK/build.properties 
sudo sed -i -e "s/ant.build.javac.target=1.6/ant.build.javac.target=1.7/" $OPENCPS_SDK/build.properties
cd $FOLDER &&  download $LIBHTTP -O $FOLDER > /dev/null 2>&1 && sudo cp -rf $FOLDER/httpclient-osgi-4.3.jar $APP_WEBINF/lib/httpclient-osgi-4.3.jar && sudo rm -rf $FOLDER/httpclient-osgi-4.3.jar
echo "===================================="
echo "||  Building OpenCPS file deploy  ||" 
echo "===================================="
source /etc/profile.d/env.sh
echo -n "[INFO] Installing Apache Ivy: "
sudo \cp -rf /opt/opencps/portlets/opencps-portlet/docroot/WEB-INF/src/org/opencps/accountmgt/dao/service.xml /opt/opencps/portlets/opencps-portlet/docroot/WEB-INF/
$ANT_HOME/bin/ant -buildfile /opt/opencps/portlets/opencps-portlet/build.xml build-service >> $FOLDER/build_opencps.log || ERR=1
if [[ $ERR != 1 ]]; then
    echo -e "${green}DONE${nc}"
else
    echo -e "${red}[ERROR]${nc} Something wrong here. Please check /tmp/build_opencps.log for more infomation"
    return
fi

echo -n "[INFO] Build Accountmgt service: "
\cp -f $APP_WEBINF/$SERVICE_ACCOUNT $APP_WEBINF/service.xml
$ANT_HOME/bin/ant -buildfile $APP_BUILDXML build-service >> $FOLDER/build_opencps.log || ERR=1
if [[ $ERR != 1 ]]; then
    echo -e "${green}DONE${nc}"
else
    echo -e "${red}[ERROR]${nc} Something wrong here. Please check $FOLDER/build_opencps.log for more infomation"
    return
fi

echo -n "[INFO] Build Datamgt service: "
\cp -rf $APP_WEBINF/$SERVICE_DATA $APP_WEBINF/service.xml
$ANT_HOME/bin/ant -buildfile $APP_BUILDXML build-service >> $FOLDER/build_opencps.log || ERR=1
if [[ $ERR != 1 ]]; then
    echo -e "${green}DONE${nc}"
else
    echo -e "${red}[ERROR]${nc} Something wrong here. Please check /tmp/build_opencps.log for more infomation"
    return
fi

echo -n "[INFO] Build Processmgt service: "
\cp -rf $APP_WEBINF/$SERVICE_PROCESS $APP_WEBINF/service.xml
$ANT_HOME/bin/ant -buildfile $APP_BUILDXML build-service >> $FOLDER/build_opencps.log || ERR=1
if [[ $ERR != 1 ]]; then
    echo -e "${green}DONE${nc}"
else
    echo -e "${red}[ERROR]${nc} Something wrong here. Please check /tmp/build_opencps.log for more infomation"
    return
fi

echo -n "[INFO] Build Paymentmgt service: "
\cp -rf $APP_WEBINF/$SERVICE_PAYMENT $APP_WEBINF/service.xml
$ANT_HOME/bin/ant -buildfile $APP_BUILDXML build-service >> $FOLDER/build_opencps.log || ERR=1
if [[ $ERR != 1 ]]; then
    echo -e "${green}DONE${nc}"
else
    echo -e "${red}[ERROR]${nc} Something wrong here. Please check /tmp/build_opencps.log for more infomation"
    return
fi

echo -n "[INFO] Build Servicemgt service: "
\cp -rf $APP_WEBINF/$SERVICE_SERVICE $APP_WEBINF/service.xml
$ANT_HOME/bin/ant -buildfile $APP_BUILDXML build-service >> $FOLDER/build_opencps.log || ERR=1
if [[ $ERR != 1 ]]; then
    echo -e "${green}DONE${nc}"
else
    echo -e "${red}[ERROR]${nc} Something wrong here. Please check /tmp/build_opencps.log for more infomation"
    return
fi

echo -n "[INFO] Build Dossiermgt service: "
\cp -rf $APP_WEBINF/$SERVICE_DOSSIER $APP_WEBINF/service.xml
$ANT_HOME/bin/ant -buildfile $APP_BUILDXML build-service >> $FOLDER/build_opencps.log || ERR=1
if [[ $ERR != 1 ]]; then
    echo -e "${green}DONE${nc}"
else
    echo -e "${red}[ERROR]${nc} Something wrong here. Please check /tmp/build_opencps.log for more infomation"
    return
fi

echo -n "[INFO] Build Usermgt service: "
\cp -rf $APP_WEBINF/$SERVICE_USER $APP_WEBINF/service.xml
$ANT_HOME/bin/ant -buildfile $APP_BUILDXML build-service build-service >> $FOLDER/build_opencps.log || ERR=1
if [[ $ERR != 1 ]]; then
    echo -e "${green}DONE${nc}"
else
    echo -e "${red}[ERROR]${nc} Something wrong here. Please check /tmp/build_opencps.log for more infomation"
    return
fi

echo -n "[INFO] Build API service: "
\cp -rf $APP_WEBINF/$SERVICE_API $APP_WEBINF/service.xml
$ANT_HOME/bin/ant -buildfile $APP_BUILDXML build-service >> $FOLDER/build_opencps.log || ERR=1
if [[ $ERR != 1 ]]; then
    echo -e "${green}DONE${nc}"
else
    echo -e "${red}[ERROR]${nc} Something wrong here. Please check /tmp/build_opencps.log for more infomation"
    return
fi

echo -n "[INFO] Build Holidayconfig service: "
\cp -rf $APP_WEBINF/$SERVICE_HOLIDAY $APP_WEBINF/service.xml
$ANT_HOME/bin/ant -buildfile $APP_BUILDXML build-service >> $FOLDER/build_opencps.log || ERR=1
if [[ $ERR != 1 ]]; then
    echo -e "${green}DONE${nc}"
else
    echo -e "${red}[ERROR]${nc} Something wrong here. Please check /tmp/build_opencps.log for more infomation"
    return
fi

echo -n "[INFO] Build Statisticsmgt service: "
\cp -rf $APP_WEBINF/$SERVICE_STATISTICS $APP_WEBINF/service.xml
$ANT_HOME/bin/ant -buildfile $APP_BUILDXML build-service >> $FOLDER/build_opencps.log || ERR=1
if [[ $ERR != 1 ]]; then
    echo -e "${green}DONE${nc}"
else
    echo -e "${red}[ERROR]${nc} Something wrong here. Please check /tmp/build_opencps.log for more infomation"
    return
fi

echo -n "[INFO] Build Notification service: "
\cp -rf $APP_WEBINF/$SERVICE_NOTIFICATION $APP_WEBINF/service.xml
$ANT_HOME/bin/ant -buildfile $APP_BUILDXML build-service >> $FOLDER/build_opencps.log || ERR=1
if [[ $ERR != 1 ]]; then
    echo -e "${green}DONE${nc}"
else
    echo -e "${red}[ERROR]${nc} Something wrong here. Please check /tmp/build_opencps.log for more infomation"
    return
fi


echo -n "[INFO] Build Postal service: "
\cp -rf $APP_WEBINF/$SERVICE_POSTAL $APP_WEBINF/service.xml
$ANT_HOME/bin/ant -buildfile $APP_BUILDXML build-service >> $FOLDER/build_opencps.log || ERR=1
if [[ $ERR != 1 ]]; then
    echo -e "${green}DONE${nc}"
else
    echo -e "${red}[ERROR]${nc} Something wrong here. Please check /tmp/build_opencps.log for more infomation"
    return
fi

cd $APP_WEBINF/src/org/opencps/api/service/base/ && rm -rf ApiServiceLocalServiceBaseImpl.java 
download $APISERVICE -P $APP_WEBINF/src/org/opencps/api/service/base/ 2>&1 >> /dev/null

echo -n "[INFO] Compile: "
$ANT_HOME/bin/ant -buildfile $APP_BUILDXML compile >> $FOLDER/build_opencps.log || ERR=1
if [[ $ERR != 1 ]]; then
    echo -e "${green}DONE${nc}"
else
    echo -e "${red}[ERROR]${nc} Something wrong here. Please check /tmp/build_opencps.log for more infomation"
    return
fi

echo -n "[INFO] Build-taglib: "
$ANT_HOME/bin/ant -buildfile $APP_BUILDXML build-taglib >> $FOLDER/build_opencps.log || ERR=1
if [[ $ERR != 1 ]]; then
    echo -e "${green}DONE${nc}"
else
    echo -e "${red}[ERROR]${nc} Something wrong here. Please check /tmp/build_opencps.log for more infomation"
    return
fi

echo -n "[INFO] Deploy Opencps Porlet: "
$ANT_HOME/bin/ant -buildfile $APP_BUILDXML deploy >> $FOLDER/build_opencps.log || ERR=1
if [[ $ERR != 1 ]]; then
    echo -e "${green}DONE${nc}"
else
    echo -e "${red}[ERROR]${nc} Something wrong here. Please check /tmp/build_opencps.log for more infomation"
    return
fi

touch $OPENCPS_SDK/hooks/opencps-hook/build.xml
echo '<?xml version="1.0"?>' > $OPENCPS_SDK/hooks/opencps-hook/build.xml
echo '<!DOCTYPE project>' >> $OPENCPS_SDK/hooks/opencps-hook/build.xml
echo '<project name="opencps-hook" basedir="." default="deploy">' >> $OPENCPS_SDK/hooks/opencps-hook/build.xml
echo '<import file="../build-common-hook.xml"/>' >> $OPENCPS_SDK/hooks/opencps-hook/build.xml
echo '</project>' >> $OPENCPS_SDK/hooks/opencps-hook/build.xml

echo -n "[INFO] Deploy Opencps Hooks: "
$ANT_HOME/bin/ant -buildfile $APP_BUILDXML_HOOK deploy >> $FOLDER/build_opencps.log || ERR=1
if [[ $ERR != 1 ]]; then
    echo -e "${green}DONE${nc}"
else
    echo -e "${red}[ERROR]${nc} Something wrong here. Please check /tmp/build_opencps.log for more infomation"
    return
fi

echo -n "[INFO] Deploy Opencps Themes: "
$ANT_HOME/bin/ant -buildfile $APP_BUILDXML_THEME deploy >> $FOLDER/build_opencps.log || ERR=1
if [[ $ERR != 1 ]]; then
    echo -e "${green}DONE${nc}"
else
    echo -e "${red}[ERROR]${nc} Something wrong here. Please check /tmp/build_opencps.log for more infomation"
    return
fi

echo "[INFO] Building OpenCPS from Source Code has been successful"
echo "[INFO] OpenCPS Deployed files are stored in /opt/server/deploy"
