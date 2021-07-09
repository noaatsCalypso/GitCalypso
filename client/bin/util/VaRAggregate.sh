#!/bin/bash

. ${ERS_HOME}/bin/calypso_ers.sh

ERS_SERVICE_HOME=${ERS_HOME}/services/webapps/risk-services/WEB-INF
WS_CLASSPATH=${ERS_SERVICE_HOME}/lib/xp.jar:${ERS_SERVICE_HOME}/lib/commons-math-1.0.jar:${ERS_SERVICE_HOME}/lib/ers-calypso_riskshared.jar:${ERS_SERVICE_HOME}/classes

export CLASSPATH=${CLASSPATH}:${WS_CLASSPATH}

${GROOVY_HOME}/bin/groovy ${ERS_HOME}/bin/VaRAggregate.groovy $*
