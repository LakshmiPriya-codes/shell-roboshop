AMI_ID="ami-0220d79f3f480ecf5"
ZONE_ID="Z0185038DV6OKNY1Q01D"
DOMAIN_NAME="lpdaws.online"

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"


###Validation###

if [ $# -lt 2 ]; then
    echo -e "$R ERROR:: Atleast 2 arguments required $N"
    echo "USAGE: $0 [create/delete] [instance1] [instance2...]"
    exit 1
fi

Action=$1
shift # first argumented will be removed

if [ $Action != "create" ] && [ $Action != "destroy" ]; then

       echo " $R ERROR :: First argument must be either create or delete $N "
       echo "USAGE: $0 [create/delete] [instance1] [instance2...]"  
       exit 1

fi

