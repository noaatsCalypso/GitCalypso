@echo off

rem ------------------------------------------------------------
rem  this batch file is used to generate the bindings that are used by the connection factory.
rem  replace InputQueueName with the name of the input queue
rem  replace OutputQueueName with the name of the output queue
rem  replace QM_Name with the name of the Queue Manager
rem  change the classpath to the appropriate path
rem -------------------------------------------------------------

echo + Creating script for object creation within JMSAdmin
echo del qcf(QueueConnectionFactory) > uploadermqsetup.scp
echo del q(OutputQueueName) >> uploadermqsetup.scp
echo del q(InputQueueName) >> uploadermqsetup.scp
echo def qcf(QueueConnectionFactory) qmgr(QM_Name) >> uploadermqsetup.scp
echo def q(OutputQueueName) qu(OutputQueueName) qmgr(QM_Name) tc(JMS)>> uploadermqsetup.scp
echo def q(InputQueueName) qu(InputQueueName) qmgr(QM_Name) tc(JMS)>> uploadermqsetup.scp
echo end >> uploadermqsetup.scp

set CLASSPATH="C:\tools\IBM\MQS\java\lib\com.ibm.mq.jar;C:\tools\IBM\MQS\java\lib\com.ibm.mqjms.jar"
echo + CLASSPATH=%CLASSPATH%
echo + Calling JMSAdmin in batch mode to create objects
java -DMQJMS_LOG_DIR="%MQ_JAVA_DATA_PATH%"\log -DMQJMS_TRACE_DIR="%MQ_JAVA_DATA_PATH%"\errors -DMQJMS_INSTALL_PATH="%MQ_JAVA_INSTALL_PATH%" com.ibm.mq.jms.admin.JMSAdmin < uploadermqsetup.scp

echo + Administration done; tidying up files
del uploadermqsetup.scp

echo + Done!


