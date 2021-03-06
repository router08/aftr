#! /bin/sh
# $Id: genconfig.sh,v 1.37 2010/03/07 18:10:19 nanard Exp $
# miniupnp daemon
# http://miniupnp.free.fr or http://miniupnp.tuxfamily.org/
# (c) 2006-2009 Thomas Bernard
# This software is subject to the conditions detailed in the
# LICENCE file provided within the distribution

RM="rm -f"
CONFIGFILE="config.h"
CONFIGMACRO="__CONFIG_H__"

# version reported in XML descriptions
#UPNP_VERSION=20070827
UPNP_VERSION=`date +"%Y%m%d"`
# Facility to syslog
LOG_MINIUPNPD="LOG_DAEMON"

# detecting the OS name and version
OS_NAME=`uname -s`
OS_VERSION=`uname -r`

${RM} ${CONFIGFILE}

echo "/* MiniUPnP Project" >> ${CONFIGFILE}
echo " * http://miniupnp.free.fr/ or http://miniupnp.tuxfamily.org/" >> ${CONFIGFILE}
echo " * (c) 2006-2009 Thomas Bernard" >> ${CONFIGFILE}
echo " * generated by $0 on `date` */" >> ${CONFIGFILE}
echo "#ifndef $CONFIGMACRO" >> ${CONFIGFILE}
echo "#define $CONFIGMACRO" >> ${CONFIGFILE}
echo "" >> ${CONFIGFILE}
echo "#include <inttypes.h>" >> ${CONFIGFILE}
echo "" >> ${CONFIGFILE}
echo "#define UPNP_VERSION	\"$UPNP_VERSION\"" >> ${CONFIGFILE}

# OS Specific stuff
case $OS_NAME in
	Linux)
		OS_URL=http://www.kernel.org/
		KERNVERA=`echo $OS_VERSION | awk -F. '{print $1}'`
		KERNVERB=`echo $OS_VERSION | awk -F. '{print $2}'`
		KERNVERC=`echo $OS_VERSION | awk -F. '{print $3}'`
		KERNVERD=`echo $OS_VERSION | awk -F. '{print $4}'`
		#echo "$KERNVERA.$KERNVERB.$KERNVERC.$KERNVERD"
		# Debian GNU/Linux special case
		if [ -f /etc/debian_version ]; then
			OS_NAME=Debian
			OS_VERSION=`cat /etc/debian_version`
			OS_URL=http://www.debian.org/
		fi
		# use lsb_release (Linux Standard Base) when available
		LSB_RELEASE=`which lsb_release`
		if [ 0 -eq $? ]; then
			OS_NAME=`${LSB_RELEASE} -i -s`
			OS_VERSION=`${LSB_RELEASE} -r -s`
			case $OS_NAME in
				Debian)
					OS_URL=http://www.debian.org/
					OS_VERSION=`${LSB_RELEASE} -c -s`
					;;
				Ubuntu)
					OS_URL=http://www.ubuntu.com/
					OS_VERSION=`${LSB_RELEASE} -c -s`
					;;
			esac
		fi
		;;
	*)
		echo "Unknown OS : $OS_NAME"
		echo "Please contact the author at http://miniupnp.free.fr/ or http://miniupnp.tuxfamily.org/."
		exit 1
		;;
esac

echo "Configuring compilation for [$OS_NAME] [$OS_VERSION] with extended NAT-PMP."
echo "Please edit config.h for more compilation options."

echo "#define OS_NAME		\"$OS_NAME\"" >> ${CONFIGFILE}
echo "#define OS_VERSION	\"$OS_NAME/$OS_VERSION\"" >> ${CONFIGFILE}
echo "#define OS_URL		\"${OS_URL}\"" >> ${CONFIGFILE}
echo "" >> ${CONFIGFILE}

echo "/* syslog facility to be used by miniupnpd */" >> ${CONFIGFILE}
echo "#define LOG_MINIUPNPD		 ${LOG_MINIUPNPD}" >> ${CONFIGFILE}
echo "" >> ${CONFIGFILE}

echo "/* Uncomment the following line to allow miniupnpd to be" >> ${CONFIGFILE}
echo " * controlled by miniupnpdctl */" >> ${CONFIGFILE}
echo "/*#define USE_MINIUPNPDCTL*/" >> ${CONFIGFILE}
echo "" >> ${CONFIGFILE}

echo "/* Comment the following line to disable NAT-PMP operations */" >> ${CONFIGFILE}
echo "#define ENABLE_NATPMP" >> ${CONFIGFILE}
echo "" >> ${CONFIGFILE}

echo "/* Uncomment the following line to enable caching of results of" >> ${CONFIGFILE}
echo " * the getifstats() function */" >> ${CONFIGFILE}
echo "/*#define ENABLE_GETIFSTATS_CACHING*/" >> ${CONFIGFILE}
echo "/* The cache duration is indicated in seconds */" >> ${CONFIGFILE}
echo "#define GETIFSTATS_CACHING_DURATION 2" >> ${CONFIGFILE}
echo "" >> ${CONFIGFILE}

echo "/* Comment the following line to use home made daemonize() func instead" >> ${CONFIGFILE}
echo " * of BSD daemon() */" >> ${CONFIGFILE}
echo "#define USE_DAEMON" >> ${CONFIGFILE}
echo "" >> ${CONFIGFILE}

echo "/* Define one or none of the two following macros in order to make some" >> ${CONFIGFILE}
echo " * clients happy. It will change the XML Root Description of the IGD." >> ${CONFIGFILE}
echo " * Enabling the Layer3Forwarding Service seems to be the more compatible" >> ${CONFIGFILE}
echo " * option. */" >> ${CONFIGFILE}
echo "/*#define HAS_DUMMY_SERVICE*/" >> ${CONFIGFILE}
echo "#define ENABLE_L3F_SERVICE" >> ${CONFIGFILE}
echo "" >> ${CONFIGFILE}

echo "/* Experimental UPnP Events support. */" >> ${CONFIGFILE}
echo "/*#define ENABLE_EVENTS*/" >> ${CONFIGFILE}
echo "" >> ${CONFIGFILE}

echo "#endif" >> ${CONFIGFILE}

exit 0
