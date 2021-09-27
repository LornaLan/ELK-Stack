#!/bin/bash
ip_list=("10.0.0.5 10.0.0.6 10.0.0.8")

for ip in ${ip_list[@]}
do
    for count in {0..200..1}
    do
        # printf "wget download $count times at host $ip"

        # use wget to generate web requests
        # use -O to rediect download to NULL, -q to turn off wget's output
        wget -O /dev/null -q $ip

        # Just in case the event is not picked up by metricbeat, delay for 1 second
        sleep 1
    done
done

# remove all the downloaded files, if any
rm -rf *index.html*