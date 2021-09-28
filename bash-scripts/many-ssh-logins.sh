#!/bin/bash
ip_list=("10.0.0.5 10.0.0.6 10.0.0.8")
username_list=("sysadmin" "admin" "azuser" "user")

for ip in ${ip_list[@]}
do
    for count in {0..2..1}
    do
        for name in ${username_list[@]} 
        do
            printf "attemp login $count to remote host at $ip with username $name\n"
            
            # somehow the "public key denied" event is not logged
            # ssh webadmin@$ip

            # however, a different user name login attemp is logged
            # webadmin or root won't trigger filebeat, but a non-existent user will
            ssh $name@$ip

            # Just in case the event is not picked up by filebeat, delay for 1 second
            sleep 1
        done
    done
done