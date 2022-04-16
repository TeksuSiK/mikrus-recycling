#!/bin/sh

echo discord=$discord >> /etc/environment

cron && tail -f /var/log/cron.log
