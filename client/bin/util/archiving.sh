#!/bin/bash

if [ -z "${CALYPSO_HOME}" ]
then
   export CALYPSO_HOME=/usr/local/calypso
fi

if [ -z "${ERS_HOME}" ]
then
   export ERS_HOME=/usr/local/calypso/ers
fi

if [ -z "${JAVA_HOME}" ]
then
   export JAVA_HOME=/usr/java
fi

. ${ERS_HOME}/bin/calypso_ers.sh

## -valuedate yyyy-MM-dd
java -Djava.security.egd=file:/dev/./urandom com.calypso.engine.risk.util.DailyArchiving -env Rel900 $*


