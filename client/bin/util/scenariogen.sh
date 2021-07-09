#!/bin/bash

. ${ERS_HOME}/bin/calypso_ers.sh

SGPATH=${ERS_HOME}/modules/scenariogenerator
SGLIBCLASSPATH=${GROOVY_HOME}/lib/asm-2.2.jar:${GROOVY_HOME}/lib/asm-attrs-2.2.jar:${GROOVY_HOME}/lib/antlr-2.7.5.jar:${SGPATH}/jars/cglib-2.1.3.jar:${SGPATH}/jars/commons-collections-2.1.1.jar:${SGPATH}/jars/concurrent-1.3.2.jar:${SGPATH}/jars/dom4j-1.6.1.jar:${SGPATH}/jars/hibernate3.jar:${SGPATH}/jars/jta.jar

export CLASSPATH=${SGPATH}/jars:${SGPATH}/jars/ers-calypso_scenariogen.jar:${CLASSPATH}:${SGLIBCLASSPATH}

${GROOVY_HOME}/bin/groovy ${ERS_HOME}/bin/util/scenariogen.groovy $*

