#!/bin/bash


LOG_FOLDER="/var/log/roboshop"
sudo mkdir -p / $LOG_FOLDER
sudo chown -R ec2-user:ec2-user $LOG_FOLDER
sudo chmod -R 755 $LOG_FOLDER
LOGS_FILE="$LOGS_FOLDER/$0.log"
USERID=$(id -u)
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"



 if [ $USERID -ne 0 ]; then
  echo -e "$TIMESTAMP [Error] $R Please run this script with root access $N" | tee -a $LOGS_FILE 
  exit 1 
 fi  

validate(){
  if [ $1 -ne 0 ]; then
    echo -e "$TIMESTAMP [Error] $2 .... $R Failure $N" | tee -a $LOGS_FILE
    exit 1
  else
    echo -e " $TIMESTAMP [Info] $2 .... $G Success $N" | tee -a $LOGS_FILE
 fi

}

dnf module disable redis -y
dnf module enable redis:7 -y
dnf install redis -y 
validate $? "Installing Redis: 7" 

 sed -i     -e 's/127.0.0.1/0.0.0.0/g' -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf
 validate $? "Allowing remote connections"

 systemctl enable redis 
 systemctl start redis 
 validate $? "Started redis"
