#! /bin/sh

if [ -z "${CALYPSO_HOME}" ]
then
   export CALYPSO_HOME=/opt/calypso/800
fi

if [ -z "${ERS_HOME}" ]
then
   export ERS_HOME=/opt/calypso/ers
fi

if [ -z "${GROOVY_HOME}" ]
then
   export GROOVY_HOME=/opt/calypso/groovy-1.0-jsr-05
fi

if [ -z "${JAVA_HOME}" ]
then
   export JAVA_HOME=/usr/jdk1.5.0
fi

. ${ERS_HOME}/bin/calypso_ers.sh

${GROOVY_HOME}/bin/groovy ${ERS_HOME}/bin/StopRiskEngines.groovy $*

sleep 10

${ERS_HOME}/bin/start_ers_broker.sh
sleep 5

${ERS_HOME}/bin/start_ers_engine.sh
sleep 5

${ERS_HOME}/bin/start_ers_limitengine.sh
sleep 5

${ERS_HOME}/bin/start_ers_creditengine.sh

