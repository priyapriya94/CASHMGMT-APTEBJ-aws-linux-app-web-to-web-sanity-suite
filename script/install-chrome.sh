#!/bin/bash
APP_HOME_DIR='/opt/apt/web-to-web-sanity-suite'
CHROME_DRIVER_VERSION=`curl -sS https://chromedriver.storage.googleapis.com/LATEST_RELEASE`

#Setting up python3.8 and installed required python packages
yum -y groupinstall "Development Tools" && yum -y install openssl-devel bzip2-devel libffi-devel
wget https://www.python.org/ftp/python/3.8.3/Python-3.8.3.tgz && tar xvf Python-3.8.3.tgz
cd Python-3.8*/ && ./configure --enable-optimizations && make altinstall
pip3.8 install -r /tmp/upload/requirements.txt

#Install required python packages using pip
mkdir -p ${APP_HOME_DIR}
pip3.8 install web_to_web_automation -i https://artifactory.tools.thcoe.ca/artifactory/api/pypi/python/simple -t ${APP_HOME_DIR}/

#Installing Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm 1>/dev/null
yum install ./google-chrome-stable_current_x86_64.rpm -y
wget -N https://chromedriver.storage.googleapis.com/$CHROME_DRIVER_VERSION/chromedriver_linux64.zip -P /tmp/
unzip /tmp/chromedriver_linux64.zip -d /tmp/
mv /tmp/chromedriver ${APP_HOME_DIR}/
chmod +x ${APP_HOME_DIR}/chromedriver
ln -s ${APP_HOME_DIR}/chromedriver /usr/local/bin/chromedriver

# Remove obsolete packages
rm /tmp/chromedriver_linux64.zip

# Moved service start script and required certs
mv /tmp/upload/start.sh ${APP_HOME_DIR}/
mv /tmp/upload/mutual-auth-certs/dev/* ${APP_HOME_DIR}/robot_framework/test_data/pfs/dev/certs
mv /tmp/upload/mutual-auth-certs/qa/* ${APP_HOME_DIR}/robot_framework/test_data/pfs/qa/certs
mv /tmp/upload/mutual-auth-certs/stage/* ${APP_HOME_DIR}/robot_framework/test_data/pfs/stage/certs

# Execute permission for start script
chmod +x ${APP_HOME_DIR}/start.sh

#change ownership of directory
chown -R apt: ${APP_HOME_DIR}/

#List contents
ls -R ${APP_HOME_DIR}

#verify versions
#google-chrome --version
#${APP_HOME_DIR}/chromedriver --version
