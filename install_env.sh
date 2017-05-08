#!/usr/bin/env bash

#JAVA_PATH='/usr/java'
JAVA_FILE='http://thfiles-fc/builds/support/jdk-8u112-linux-x64.rpm'
#MAVEN_PATH='/usr/maven'
MAVEN_FILE='http://thfiles-fc/builds/support/apache-maven-3.5.0-bin.zip'
#GRADLE_PATH='/usr/gradle'
GRADLE_FILE='http://thfiles-fc/builds/support/gradle-3.5-bin.zip'

function installSupportEnv {
    echo '>> Install Support Env'

    if ! (rpm -qa | grep nano); then
        echo 'install nano'
        yum install nano
    fi

    if ! (rpm -qa | grep wget); then
        echo 'install wget'
        yum install wget
    fi

    if ! (rpm -qa | grep unzip); then
        echo 'install unzip'
        yum install unzip
    fi

    if ! (rpm -qa | grep iptables-services); then
        echo 'install iptables-services'
        yum install iptables-services
    fi
}

function updateIpTables {
    echo '>> Update ip tables'

    iptables -A INPUT -i eth0 -p tcp --dport 80 -m state --state NEW,ESTABLISHED -j ACCEPT
    iptables -A OUTPUT -o eth0 -p tcp --dport 80 -m state --state NEW,ESTABLISHED -j ACCEPT

    iptables -A INPUT -i eth0 -p tcp --dport 8480 -m state --state NEW,ESTABLISHED -j ACCEPT
    iptables -A OUTPUT -o eth0 -p tcp --dport 8480 -m state --state NEW,ESTABLISHED -j ACCEPT

    sudo /sbin/iptables-save
    systemctl restart iptables
}

function installJava8 {
    echo '>> Install Java'
    cd /root

    if yum list jdk1.8.0_112.x86_64; then
        echo 'Java 1.8 ready'
    else
        echo 'Downloading and installing Java 1.8'

        wget ${JAVA_FILE}
        sudo yum -y install jdk-8u112-linux-x64.rpm

        grep -q -F "export JAVA_HOME=" /root/.bashrc || echo "export JAVA_HOME=/usr/java/jdk1.8.0_112" >> /root/.bashrc
        grep -q -F "export PATH=${JAVA_HOME}/bin" /root/.bashrc || echo 'export PATH=/usr/java/jdk1.8.0_112/bin:$PATH' >> /root/.bashrc

        rm -rf jdk-*
        echo 'Java 1.8 ready'
    fi

    source /root/.bashrc
}

function installMaven3 {
    echo '>> Install Maven'
    cd /root

    local maven_version=`mvn -version`

    if [[ ${maven_version} == *"Apache Maven 3.5.0"* ]]; then
        echo 'Maven 3.5.0 ready'
    else
        echo 'Downloading and installing Maven 3.5.0'

        wget ${MAVEN_FILE}
        mkdir /usr/maven
        unzip -d /root/zip/maven apache-maven*

        grep -q -F "export MAVEN_HOME=" /root/.bashrc || echo "export MAVEN_HOME=/usr/maven/apache-maven-3.5.0" >> /root/.bashrc
        grep -q -F "export PATH=${MAVEN_HOME}/bin" /root/.bashrc || echo 'export PATH=/usr/maven/apache-maven-3.5.0/bin:$PATH' >> /root/.bashrc

        rm -rf apache-maven-*
        echo 'Maven 3.5.0 ready'
    fi

    source /root/.bashrc
}

function installGradle3 {
    echo '>> Install Gradle'
    cd /root

    local gradle_version=`gradle -v`

    if [[ ${gradle_version} == *"Gradle 3.5"* ]]; then
        echo 'Gradle 3.5 ready'
    else
        echo 'Downloading and installing Gradle 3.5'

        wget ${GRADLE_FILE}
        mkdir /usr/gradle
        unzip -d /usr/gradle gradle-*

        grep -q -F "export GRADLE_HOME=" /root/.bashrc || echo "export GRADLE_HOME=/usr/gradle/gradle-3.5" >> /root/.bashrc
        grep -q -F "export PATH=${GRADLE_HOME}/bin" /root/.bashrc || echo 'export PATH=/usr/gradle/gradle-3.5/bin:$PATH' >> /root/.bashrc

        rm -rf gradle-*
        echo 'Gradle 3.5 ready'
    fi

    source /root/.bashrc
}

function parseLastBuild {
    local host_url='http://thfiles/builds/PX/10.2/'
    local last_build=`wget -qO- http://thfiles/builds/PX/10.2/ | grep -Eoi '<a [^>]+>' | grep -Eo 'href="[^\"]+"' | grep -Eo '[0-9]+.[0-9]+.[0-9]+.[0-9]+_[0-9]+.[0-9]+_[a-zA-Z0-9]+'  | tail -n 1`
    echo "$host_url$last_build/ExampleCenter.zip"
}

function loadExampleCenterLatestBuild {
    echo '>> Load ExampleCenter Latest Build'
    cd /root

    rm -rf ExampleCenter.zip
    wget $(parseLastBuild)
}

installSupportEnv
updateIpTables
installJava8
installMaven3
installGradle3
loadExampleCenterLatestBuild