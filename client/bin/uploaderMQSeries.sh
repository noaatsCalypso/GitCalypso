#!/bin/sh
#This script is used to create a MQ binding file. Please make sure that the directory specified in JMSAdmin.config PROVIDER_URL exists in the disk. The usages of the script is as below:
# sudo -u <user> ./createMQbinding.sh QM TEST.SENDQ TEST.RECVQ  <hostname> <port> <client_name> <client_env_name>

QUEUE_MANAGER=$1
INPUT_QUEUE=$2
OUTPUT_QUEUE=$3
MQ_HOST=$4
MQ_PORT=$5
CLIENT=$6
ENV=$7

USER_NAME=$USER

#USER_NAME=who
BINARY_PATH="/usr/local/calypso/clients/${CLIENT}/${ENV}/jars"

SCP_FILE="${ENV}_`date +'%Y%m%d%H%M%S'`.scp"

echo "del q($INPUT_QUEUE)" >> $SCP_FILE
echo "del q($OUTPUT_QUEUE)" >> $SCP_FILE
echo "def qcf(QueueConnectionFactory) TRAN(CLIENT) HOST($MQ_HOST) PORT($MQ_PORT) qmgr($QUEUE_MANAGER) CHANNEL(SYSTEM.ADMIN.SVRCONN)" >> $SCP_FILE
echo "def q($OUTPUT_QUEUE) qu($OUTPUT_QUEUE) qmgr($QUEUE_MANAGER) tc(JMS)" >> $SCP_FILE
echo "def q($INPUT_QUEUE) qu($INPUT_QUEUE) qmgr($QUEUE_MANAGER) tc(JMS)" >> $SCP_FILE
echo "end" >> $SCP_FILE

CLASSPATH="${BINARY_PATH}/com.ibm.mq.jar:${BINARY_PATH}/com.ibm.mqjms.jar"
echo "+ CLASSPATH=$CLASSPATH"
echo "+ Calling JMSAdmin in batch mode to create objects"
java -cp $CLASSPATH -DMQJMS_LOG_DIR="/home/$USER_NAME" -DMQJMS_TRACE_DIR="/home/$USER_NAME" -DMQJMS_INSTALL_PATH="/home/$USER_NAME" com.ibm.mq.jms.admin.JMSAdmin < $SCP_FILE

echo "+ Administration done; tidying up files"
# rm $SCP_FILE