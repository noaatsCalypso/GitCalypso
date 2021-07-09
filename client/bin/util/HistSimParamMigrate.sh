#!/bin/sh

show_help=true
for arg in "$@" ; do
  if [ my"$arg" = my"-env" ] ; then
     show_help=false
  elif [ my"$arg" = my"--h"  -o my"$arg" = my"--help"  ] ; then
    show_help=true
  else
    if [  my"$arg" = my"-h"  -o  my"$arg" = my"-help" ] ; then
      show_help=true
    fi
  fi
done

# Show script help if requested
if $show_help ; then
  echo 'Usage:'
  echo $0 '-env <calypso_env> -user <calypso user> -password <calypsopwd>'
  echo '  --help, --h            print this message'
  echo '  '
  exit 1
fi


if [ -z "${CALYPSO_HOME}" ]
then
   export CALYPSO_HOME=/usr/local/calypso
fi

PRGDIR=`dirname "$0"`
ERS_HOME=
[ -z "$ERS_HOME" ] && ERS_HOME=`cd "$PRGDIR/../.." ; pwd`
echo ERS_HOME: $ERS_HOME

if [ -z "${JAVA_HOME}" ]
then
   export JAVA_HOME=/usr/java
fi

. ${ERS_HOME}/bin/calypso_ers.sh

java -Djava.security.egd=file:/dev/./urandom com.calypso.tk.risk.HistSimParamLoader $*
