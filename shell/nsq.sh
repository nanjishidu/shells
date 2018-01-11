#!/bin/sh
nsqlookupd -http-address="0.0.0.0:4161" -tcp-address="0.0.0.0:4160" &
nsqd -data-path=/tmp/nsq1 -mem-queue-size=1000000 --lookupd-tcp-address=127.0.0.1:4160 -tcp-address="0.0.0.0:4150" -http-address="0.0.0.0:4151" &
nsqd -data-path=/tmp/nsq2 --lookupd-tcp-address=127.0.0.1:4160 -tcp-address="0.0.0.0:4152" -http-address="0.0.0.0:4153" &
nsqd -data-path=/tmp/nsq3 --lookupd-tcp-address=127.0.0.1:4160 -tcp-address="0.0.0.0:4154" -http-address="0.0.0.0:4155" &
nsqadmin --lookupd-http-address=127.0.0.1:4161 &