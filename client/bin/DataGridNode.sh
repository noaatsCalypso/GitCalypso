#!/bin/sh

# To add comments to this script, please use single #
# Comments with double # will be treated as help text

cd `dirname $0`

# Need to set the below settings to configure the coherence host and port information
#export JAVA_OPTS="-Xmx=2g -Xms=2g -Djava.security.egd=file:/dev/../dev/urandom -Ddatagrid.impl=coherence -Dcom.sun.management.jmxremote -Dtangosol.coherence.management=all -Dtangosol.coherence.management.remote=true  -Dtangosol.coherence.clusteraddress=225.2.3.0 -Dtangosol.coherence.clusterport=9566  -Dtangosol.coherence.management.report.autostart=false"

helpText() {
        grep "##" `basename $0` | grep -Ev "grep" | cut -d'#' -f3 | cut -c 2-
}

if [ "$1" = "--help" ] ; then
        helpText
        exit 0
fi

JAVA_OPTS="$JAVA_OPTS"
export JAVA_OPTS

## -env <CALYPSO_ENV>
##     To supply the name of the Env in which you wish to run.
## 
## -log
##     To log all tracing to a file in your USER_HOME/Calypso directory.
## 
## -user <USERNAME>
##     To supply the name of the Calypso user.
## 
## -password <PASSWORD>
##     To supply Calypso user's password.
## 
## -nogui
##     To run the application at the command line only, with no graphical user interface (GUI).
## 
## -logprefix <FILENAME>
##     To log all tracing to the file specified in the file_name argument. The file name can be a 
##     complete path name. The application will create the file; it need not already exist. Use 
##     this instead of the -log argument if you want to specify the path and file name. 
## 
## -userhome <DIRECTORY>
##     To set your default directory.
## 
## -logdir <DIRECTORY>
##     To specify the directory for logs.
## 


bash ./calypso com.calypso.apps.startup.StartDataGridNode -env @CALYPSO_ENV@ -log $*

