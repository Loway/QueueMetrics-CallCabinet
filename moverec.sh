#!/bin/bash

#Log File
LOGFILE="/home/callcabinet/move.out"

#Logic in the script is as follows:
#1) Calculate call duration (note - this goes from the call start time, which is not necessarily the start of the call recording):
CALLSTART=${5}T${6}
CALLSTARTSEC=`date -d "${5} ${6}" "+%s"`
CALLENDSEC=`date  "+%s"`
#Confirm the location of the recordings as set in the CCModule
CCSTAGING=/home/callcabinet/recordings

FOLDERS=`date +"%Y/%m/%d"`

#CALLDUR=$((CALLENDSEC-CALLSTARTSEC))
CALLDUR=0

SRCFILE=${1}

if [ "${CALLDUR}" -le 0 ]
then
  CALLDUR=0
fi

#2) Call Direction (there are easier ways to do this)
# Determine in our out call from prefix
FILEBASE=`basename $SRCFILE`
CALLDIR=${FILEBASE%%-*}

#We get the agent extension from the filename


if [ "${CALLDIR}" = "IN" ] || [ "${CALLDIR}" = "in" ] || [ "${CALLDIR}" = "" ]
then
   CALLDIR="INCOMING"
   REMOTENUM=${CALLER}
   USEREXT=${AMPUSER}

   if [ -z "${USEREXT}" ]
   then
      USEREXT=`echo $FILEBASE | cut -d '-' -f 2`
   fi

   if [ -z "${REMOTENUM}" ]
   then
      REMOTENUM=`echo $FILEBASE | cut -d '-' -f 3`
   fi

fi
 
if [ "${CALLDIR}" = "OUT" ] || [ "${CALLDIR}" = "out" ] || [ "${CALLDIR}" = "force" ]
then

   CALLDIR="OUTGOING"
   USEREXT=${AMPUSER}
   REMOTENUM=${CALLED}

   if [ -z "${USEREXT}" ]
   then
      USEREXT=`echo $FILEBASE} | cut -d '-' -f 3`
   fi

   if [ -z "${REMOTENUM}" ]
   then
      REMOTENUM=`echo $FILEBASE | cut -d '-' -f 2`
   fi

fi

#3) Rename the file
DSTFILE=${CALLSTART}_${CALLDUR}_${CALLDIR}_${REMOTENUM}_${USEREXT}_${8}.WAV
mkdir -p /home/callcabinet/recordings/${FOLDERS}
mv ${SRCFILE}* ${CCSTAGING}/${FOLDERS}/${DSTFILE}

echo '------------------------------------'>> ${LOGFILE}
echo 'Srcfile: ' ${SRCFILE} >> ${LOGFILE}
echo 'Ccstaging ' ${CCSTAGING} >> ${LOGFILE}
echo 'Folders: ' ${FOLDERS} >> ${LOGFILE}
echo 'Destfile: ' ${DSTFILE} >> ${LOGFILE}
echo 'Callerid(number):' ${3} >> ${LOGFILE}
echo 'CDR(dst):' ${4} >> ${LOGFILE}
echo 'CDR(start):' ${5} ${6} >> ${LOGFILE}
echo 'CDR(src):' ${7} >> ${LOGFILE}
echo 'UNIQUEID:' ${8} >> ${LOGFILE}
echo 'DURATION:' ${CALLDUR} >> ${LOGFILE}
echo 'DIRECTION:' ${CALLDIR} >> ${LOGFILE}
echo 'AMPUSER:' ${AMPUSER} >> ${LOGFILE}
echo 'REMOTENUM:' ${REMOTENUM} >> ${LOGFILE}
echo 'CALLED:' ${CALLED} >> ${LOGFILE}
echo 'CALLER:' ${CALLER} >> ${LOGFILE}
echo '------------------------------------'>> ${LOGFILE}