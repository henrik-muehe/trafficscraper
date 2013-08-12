#!/bin/bash

cron &
mysqld_safe &
sleep 5

DBCOUNT=`echo "show databases like 'traffic';" | mysql -uroot | wc -l`
if [ "$DBCOUNT" != "2" ]; then
	echo "Creating db..."
	echo "CREATE DATABASE traffic;" | mysql -uroot
	echo "GRANT ALL ON traffic.* TO traffic@localhost IDENTIFIED BY 'some_password';" | mysql -uroot
	cd /src ; mysql -utraffic -psome_password < traffic.sql
fi

crontab crontab
crontab -l

script /tmp/script -c 'cd /src ; tmux new "node /src/server.js"'
