#!/bin/bash
echo STARTING...
echo $PWD

cp $PWD/drivers/* $PWD/lib

mkdir /root/.kettle/
cp $PWD/.kettle/* /root/.kettle/
chmod -R 777 /root/.kettle/

dos2unix $PWD/jobs/cronjob
find $PWD/jobs/ -name '*.sh' | xargs dos2unix

service cron start
crontab $PWD/jobs/cronjob

mkdir $PWD/logs
> $PWD/logs/log.log
chmod -R 777 $PWD/logs
tail -f $PWD/logs/log.log
