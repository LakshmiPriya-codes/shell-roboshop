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

cp rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo
validate $? "Adding rabbitmq repo"  

dnf install rabbitmq-server -y &>> $LOGS_FILE
validate $? "Installing rabbitmq server"

systemctl enable rabbitmq-server &>> $LOGS_FILE
systemctl start rabbitmq-server  &>> $LOGS_FILE
validate $? "Enabling & Starting rabbitmq server"


rabbitmqctl add_user roboshop roboshop123   &>> $LOGS_FILE
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>> $LOGS_FILE
validate $? "setting up username and password"