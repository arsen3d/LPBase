#!/bin/bash
mkdir /report
echo "Card Name, Card GUID,  Total Power (W), Total Memory (MiB)" > /report/card.csv


nvidia_output=$(nvidia-smi --query-gpu=name,gpu_uuid,power.max_limit,memory.total --format=csv,noheader,nounits)
while IFS=, read -r card_name card_guid total_power total_memory ; do
    echo " $card_name, $card_guid, $total_power,  $total_memory " >> /report/card.csv
done  <<< "$nvidia_output"

echo "Timestamp, Utilization (%), Power Usage (W),Memory Used (MiB)" > /report/usage.csv
while true;
do
    time=$(date '+%Y-%m-%d %H:%M:%S')
    nvidia_output=$(nvidia-smi --query-gpu=utilization.gpu,power.draw,memory.used --format=csv,noheader,nounits)
    
    while IFS=, read -r  utilization power_usage  memory_used ; do
        echo "$time,  $utilization,  $power_usage,  $memory_used" >> /report/usage.csv
    done  <<< "$nvidia_output"
    
    sleep 1
done

# root@docker-desktop:/report# ls
# card.csv  usage.csv
# root@docker-desktop:/report# cat card.csv 
# Card Name, Card GUID,  Total Power (W), Total Memory (MiB)
#  NVIDIA GeForce RTX 4090,  GPU-a5f052ca-e769-ac8c-c030-d34d071229fb,  450.00,   24564 
# root@docker-desktop:/report# cat usage.csv 
# Timestamp, Utilization (%), Power Usage (W),Memory Used (MiB)
# 2024-12-06 20:16:12,  2,   63.62,   3194
# 2024-12-06 20:16:13,  3,   64.29,   3199
# 2024-12-06 20:16:14,  1,   57.63,   3284
# 2024-12-06 20:16:15,  20,   31.27,   3285
# 2024-12-06 20:16:16,  8,   29.83,   3272
# 2024-12-06 20:16:17,  1,   46.29,   3265
# 2024-12-06 20:16:18,  1,   63.50,   3257
# 2024-12-06 20:16:19,  0,   63.43,   3241
# 2024-12-06 20:16:20,  5,   51.00,   3241
# 2024-12-06 20:16:21,  3,   30.53,   3224
# 2024-12-06 20:16:22,  3,   27.87,   3224
# 2024-12-06 20:16:23,  0,   53.19,   3224
# 2024-12-06 20:16:25,  0,   63.17,   3224
# 2024-12-06 20:16:26,  0,   62.86,   3224
# 2024-12-06 20:16:27,  6,   45.15,   3232
# 2024-12-06 20:16:28,  4,   29.98,   3224
# 2024-12-06 20:16:29,  10,   27.34,   3224
# 2024-12-06 20:16:30,  9,   25.12,   3224
# root@docker-desktop:/report#