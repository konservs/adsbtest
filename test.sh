#!/bin/bash
### BEGIN INIT INFO
#
# Provides:             dump1090
# Required-Start:       $remote_fs
# Required-Stop:        $remote_fs
# Default-Start:        2 3 4 5
# Default-Stop:         0 1 6
# Short-Description:    dump1090 initscript

#
### END INIT INFO
## Fill in name of program here.
PROG="nc 192.168.2.15 1234 | dump1090-mutability"
PROG_PATH="/usr/bin/"
PROG_ARGS="--quiet --no-fix --net"
PIDFILE="/var/run/$PROG.pid"

start() {
      if [ -e $PIDFILE ]; then
          ## Program is running, exit with error.
          echo "Error! $PROG is currently running!" 1>&2
          exit 1
      else
          ## Change from /dev/null to something like /var/log/$PROG if you want to save output.
          cd $PROG_PATH
          ./$PROG $PROG_ARGS 2>&1 >/dev/null &
          echo "$PROG started, waiting $DELAY seconds..."
          touch $PIDFILE
      fi
}

stop() {
      if [ -e $PIDFILE ]; then
          ## Program is running, so stop it
         echo "$PROG is running"
         killall $PROG
         rm -f $PIDFILE
         echo "$PROG stopped"
      else
          ## Program is not running, exit with error.
          echo "Error! $PROG not started!" 1>&2
          exit 1
      fi
}

## Check to see if we are running as root first.
## Found at http://www.cyberciti.biz/tips/shell-root-user-check-script.html
if [ "$(id -u)" != "0" ]; then
      echo "This script must be run as root" 1>&2
      exit 1
fi

case "$1" in
      start)
          start
          exit 0
      ;;
      stop)
          stop
          exit 0
      ;;
      reload|restart|force-reload)
          stop
          start
          exit 0
      ;;
      **)
          echo "Usage: $0 {start|stop|reload}" 1>&2
          exit 1
      ;;
esac

#
