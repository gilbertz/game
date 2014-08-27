#!/bin/bash
#
#
# @file    monitor.sh 
# @brief
#          monitor sjb  service
# @history

RUN_PATH="/root/weixin_game"
MONITOR_LOG="$RUN_PATH/log/monitor.log"

if [ -f ${MONITOR_LOG} ]
then
    LINES=`wc -l ${MONITOR_LOG}  | awk '{print $1}'`
    if [ ${LINES} -gt 10000 ]
    then
         > ${MONITOR_LOG}
    fi
fi

echo "-------------------------------------" >> ${MONITOR_LOG}

declare -a processes

processes=("passenger.6000" "passenger.5000" "passenger.7000"  "redis-server"  "nginx")

a_len=${#processes[@]}

PROCESS_NUM=1
for((i=0; i < a_len; i++));
do
    process=${processes[$i]}
    echo $process
    #echo ${cmds[$i]}

    PROGRAM_NUM=`ps -ef | grep $process | grep -v 'grep' | wc -l`
    echo "process num: $PROGRAM_NUM"    
 
    date=$(date "+%Y-%m-%d-%H:%M:%S")

    echo "[${date}] The number of $process is ${PROGRAM_NUM}!" >> ${MONITOR_LOG}

    if [ ${PROGRAM_NUM} -lt ${PROCESS_NUM} ]
    then
        echo "[${date}] The number of $process is not enough!" >> ${MONITOR_LOG}
        #while [ ${PROGRAM_NUM} -lt ${PROCESS_NUM} ]
        #do
           cd ${BIN_PATH}
           date1=$(date "+%Y-%m-%d-%H:%M:%S")
           #echo "[${date1}] Attempt to start $process again" >> ${MONITOR_LOG}
           info="[${date1}] ooxx: process $process fail!"
   
           echo $info
           wget -O "sms.wget.log" "http://quanapi.sinaapp.com/fetion.php?u=13818904081&p=831022sjtu&to=13818904081,13261358668&m=${info}" 
          
           cd /root/weixin_game && /bin/bash ./restart.sh 
           #sudo /etc/init.d/redis-server restart
           #`${cmds[$i]}`
           
           #if [ $? -eq 0 ]
           #then
           #    echo "[${date1}] Attempt to start $process SUCC!" >> ${MONITOR_LOG}
           #else
           #    echo "[${date1}] Attempt to start $process FAILED!" >> ${MONITOR_LOG}
           #fi
           
           sleep 60
           let PROGRAM_NUM=`ps -ef | grep '$process' | grep -v 'grep' | wc -l`
           
           #./mail_worker.sh
        #done
    fi
    let count+=1
done
exit;
