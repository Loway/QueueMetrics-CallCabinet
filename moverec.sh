#Logic in the script is as follows:
#1) Calculate call duration (note - this goes from the call start time, which is not necessarily the start of the call recording):
CALLSTART=${5}T${6}
CALLSTARTSEC=`date -d "${5} ${6}" "+%s"`
CALLENDSEC=`date  "+%s"`
#Confirm the location of the recordings as set in the CCModule
CCSTAGING=/home/callcabinet/recordings
FOLDERS=`date +"%Y/%m/%d"`
CALLDUR=$((CALLENDSEC-CALLSTARTSEC))
if [ "$CALLDUR" -le 0 ]
then
  CALLDUR=0
fi

echo 'move' >> /var/lib/asterisk/bin/move.out

#2) Call Direction (there are easier ways to do this)
# Determine in our out call from prefix
FILEBASE=`basename $SRCFILE`
echo `BASENAME $SRCFILE` >> move.out

#Here we break down the file name ($1). And look if the call is store in the "temp" folder
IFS='/' read -a myarray <<< "$1"
CALLDIRECTORY=${myarray[5]}

#If the directory is temp, it means that it's an outbound call placed there by QueueMetrics' dialplan
if [ "$CALLDIRECTORY" = "temp" ]
then
   CALLDIR="OUTGOING"

   IFS='-' read -a filenamearray <<< "$1"
   MYCALLERID=${filenamearray[4]}
   USEREXT=$AMPUSER
   REMOTENUM=$CALLED

#If the directory is not temp, it means that it's a normal inbound call, or a call that has not been made through QueueMetrics. These calls will be treated as normal inbound calls
else
   CALLDIR="INCOMING"

   IFS='-' read -a filenamearray <<< "$1"
   MYCALLERID=${filenamearray[2]}

   REMOTENUM=$CALLER
   if [ -z "$AMPUSER" ]
   then
      AMPUSER=`echo $FILEBASE | cut -d '-' -f 2`
   fi
   USEREXT=$AMPUSER
fi




#3) Rename the file
SRCFILE=$1
DSTFILE=${CALLSTART}_${CALLDUR}_${CALLDIR}_${MYCALLERID}_$3_${8}.WAV
mkdir -p /home/callcabinet/recordings/${FOLDERS}
mv ${SRCFILE}* ${CCSTAGING}/${FOLDERS}/${DSTFILE}
echo 'srcfile: ' ${SCRFILE} '- ccstaging ' ${CCSTAGING} '-folders: ' ${FOLDERS} '-destfile: ' ${DESTFILE} >> move.out
echo ${1} ${2} ${3} ${4} ${5} ${6} ${CALLDUR} ${CALLDIR} >> move.out

mv move.out ${CCSTAGING}/${FOLDERS}/