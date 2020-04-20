#!/bin/bash
LOG_FILE=/volume1/web/ip/ip-raw.txt
LOG_TEMP=/volume1/web/ip/ip-temp.txt
LOG_OUTPUT=/volume1/web/ip/ip-filtered.txt

# replace this with your own Dynamic DNS
DDNS_HOST1=your-dyndns1-hostname.ddns.net
DDNS_HOST2=your-dyndns2-hostname.ddns.net
# you can use Cloudflare 1.1.1.1 instead of Google Public DNS 8.8.8.8, or any other DNS you prefer
PUBLIC_DNS=8.8.8.8

# here you can change date format
date +"%d.%m.%Y %T" >>$LOG_FILE

nslookup $DDNS_HOST1 $PUBLIC_DNS | tail -3 | head -2 | tr '\t' ' ' | tr '\n' '\t' | paste >>$LOG_FILE
nslookup $DDNS_HOST2 $PUBLIC_DNS | tail -3 | head -2 | tr '\t' ' ' | tr '\n' '\t' | paste >>$LOG_FILE
# remove duplicate IPs and save it to output file
touch $LOG_TEMP
awk '!a[$0]++' $LOG_FILE >$LOG_TEMP && sed '/2020/{$d;N;/\n.*Name/!D;}' $LOG_TEMP >$LOG_OUTPUT
#remove temporary file
rm $LOG_TEMP

