#!/bin/bash
ip_list=("10.0.0.5 10.0.0.6 10.0.0.8")

for ip in ${ip_list[@]}
do
    for count in {0..2..1}
    do
        printf "wget download $count times at host $ip"

        # use wget to generate web requests
        wget $ip

        # Just in case the event is not picked up by metricbeat, delay for 1 second
        sleep 1
    done
done