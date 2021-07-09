#!/bin/sh

# To add comments to this script, please use single #
# Comments with double # will be treated as help text

cd `dirname $0`

helpText() {
        grep "##" `basename $0` | grep -Ev "grep" | cut -d'#' -f3 | cut -c 2-
}

if [ "$1" = "--help" ] ; then
        helpText
        exit 0
fi

if [ "$RUN_IN_BACKGROUND" = "" ] ; then
	RUN_IN_BACKGROUND="false"
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
## -dbuser <DB_USERNAME>
##     Database user name, different from application user name.
## 
## -dbpassword <DB_PASSWORD>
##     Database user password, different from application password.
## 

if [ "$RUN_IN_BACKGROUND" = "TRUE" ] ; then
	ARGS=$*
	ACTION="START"
	PID_LOCATION="./pid"
	OUT_LOCATION="./out"
	APP_NAME="$(basename $0)"

	if [ ! -d ${PID_LOCATION} ] ; then
		mkdir ${PID_LOCATION}
	fi
	if [ ! -d ${OUT_LOCATION} ] ; then
		mkdir ${OUT_LOCATION}
	fi

	while [ "$1" != "" ] ; do
		case $1 in
			--start)                ACTION="START"
						;;
			--stop)                 ACTION="STOP"
						;;
			--status)               ACTION="STATUS"
						;;
		esac
		shift
	done

	if [ "$ACTION" = "START" ] ; then
		bash ./calypso com.calypso.apps.startup.StartExecuteSQL -log ${ARGS} > ${OUT_LOCATION}/${APP_NAME}.out 2>&1 &
		echo $! > ${PID_LOCATION}/${APP_NAME}.pid
	elif [ "$ACTION" = "STOP" ] ; then
		if [ -f ${PID_LOCATION}/${APP_NAME}.pid ] ; then
			kill $(cat ${PID_LOCATION}/${APP_NAME}.pid)
		fi
	else
		if [ ! -f ${PID_LOCATION}/${APP_NAME}.pid ] ; then
			echo "OFFLINE"
		else
			ps -c $(cat ${PID_LOCATION}/${APP_NAME}.pid) > /dev/null
			RUNNING=$?
			if [ "$RUNNING" = "0" ] ; then
				echo "OK"
			else
				echo "OFFLINE"
			fi
		fi
	fi
	
else
	bash ./calypso com.calypso.apps.startup.StartExecuteSQL -log $*
fi
