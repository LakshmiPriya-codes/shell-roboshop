#!/bin/bash

LOG_FOLDER="/var/log/roboshop"
sudo mkdir -p / $LOG_FOLDER
sudo chown -R ec2-user:ec2-user $LOG_FOLDER
sudo chmod -R 755 $LOG_FOLDER
LOGS_FILE="$LOGS_FOLDER/$0.log"
SCRIPT_DIR=$PWD


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

dnf install maven -y &>>$LOGS_FILE
validate $? "Installing Maven"

id roboshop &>> $LOGS_FILE
if [ $? -ne 0 ]; then
     useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>> $LOGS_FILE
     validate $? "Creating roboshop system user"
else
    echo -e "System user roboshop alredy created .. $Y SKIIPING $N"   
fi      

rm -rf /app
validate $? "removng existing code"

rm -rf /tmp/shipping.zip
validate $? "Removing shipping zip"

mkdir -p /app    &>> $LOGS_FILE
validate $? "Creating app directory"

curl -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping-v3.zip  &>> $LOGS_FILE
cd /app 
unzip /tmp/shipping.zip  &>> $LOGS_FILE
validate $? "Downloaded and extracted shipping code "

mvn clean package  &>>$LOGS_FILE 
validate $? "Installing dependencies"

cp $SCRIPT_DIR/shipping.service /etc/systemd/system/shipping.service
validate $? "Created systemctl service"

dnf install mysql -y  &>>$LOGS_FILE
validate $? "Installing MySQL client"
