#!/bin/bash
# entrypoint.sh
# export DOCKER_NETWORK_MODE=host
#  dockerd --bridge=none --iptables=false&
#TIMEOUT=$(grep -oP '"Timeout":\s*\K\d+' /a#pp/lilypad_module.json.tmpl)
#echo "TIMEOUT: ${TIMEOUT}"  
calculate_timeout() {
    local timeout=$(grep -oP '"Timeout":\s*\K\d+' /app/lilypad_module.json.tmpl)
    local elapsed_time=$(ps -o etime= -p 1 | awk -F '[:-]' '{
        if (NF == 2)      # MM:SS
            print ($1 * 60) + $2;
        else if (NF == 3) # HH:MM:SS
            print ($1 * 3600) + ($2 * 60) + $3;
        else if (NF == 4) # D-HH:MM:SS
            print ($1 * 86400) + ($2 * 3600) + ($3 * 60) + $4;
    }')
    local remaining_time=$((timeout - elapsed_time - 2))
    if [ $remaining_time -lt 0 ]; then
        remaining_time=0
    fi
    echo $remaining_time
}
TIMEOUT=$(calculate_timeout)
echo "TIMEOUT: ${TIMEOUT}" 

/base/profile.sh &

if [ -n "${CALL_BACK}" ]; then
    export PYTHONUNBUFFERED=1
    # Your script commands here
    echo "Running entrypoint script"
    /base/frpc http -s frp.arsenum.com -P 443 -i 127.0.0.1 -l 8765 -d ${CALL_BACK}.arsenum.com -n ${CALL_BACK} --protocol wss &
    echo $@
    python /base/run_app.py $@ & 
    # Execute the command passed to the container
    # exec "$@"
    sleep ${TIMEOUT}
    exit 0
fi

exec $@