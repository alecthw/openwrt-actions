#!/bin/sh

error() {
    local msg=$1
    local exit_code=$2

    echo "Error: ${msg}" >&2

    if [ -n "${exit_code}" ]; then
        exit ${exit_code}
    fi
}

count=10
url="www.google.com"
while [ -n "$*" ]; do
    arg=$1
    shift
    case "${arg}" in
    --count | -c)
        [ -n "$1" ] || error "Option --count | -c requires an argument" 2
        count=$1
        shift
        ;;
    *)
        url=${arg}
        ;;
    esac
done

time_connect=0       # 建立到服务器的TCP连接所用的时间
time_starttransfer=0 # 在发出请求之后，Web服务器返回数据的第一个字节所用的时间
time_total=0         # 完成请求所用的时间

format="%-11s %-12s %-13s %-19s %-11s\n"
printf "${format}" Times status connect starttransfer total

count_c=0
for i in $(seq 1 ${count}); do
    result=$(curl -o /dev/null --connect-timeout 2 -k -s -w "%{http_code} %{time_connect} %{time_starttransfer} %{time_total}" https://${url})

    sta=$(echo ${result} | awk '{print $1}')
    t_c=$(echo ${result} | awk '{print $2}')
    t_s=$(echo ${result} | awk '{print $3}')
    t_t=$(echo ${result} | awk '{print $4}')

    if [ ${sta} == "000" ]; then
        continue
    fi

    count_c=$(echo "$count_c" | awk '{print $1+1}')

    t_c_ms=$(echo "${t_c}" | awk '{printf ("%.3f\n",$1*1000)}')
    t_s_ms=$(echo "${t_s}" | awk '{printf ("%.3f\n",$1*1000)}')
    t_t_ms=$(echo "${t_t}" | awk '{printf ("%.3f\n",$1*1000)}')

    printf "${format}" ${i} ${sta} ${t_c_ms} ${t_s_ms} ${t_t_ms}

    time_connect=$(echo "${time_connect} ${t_c_ms}" | awk '{printf ("%.3f\n",$1+$2)}')
    time_starttransfer=$(echo "${time_starttransfer} ${t_s_ms}" | awk '{printf ("%.3f\n",$1+$2)}')
    time_total=$(echo "${time_total} ${t_t_ms}" | awk '{printf ("%.3f\n",$1+$2)}')
done

ave_c=$(echo "${time_connect} ${count_c}" | awk '{printf ("%.3f\n",$1/$2)}')
ave_s=$(echo "${time_starttransfer} ${count_c}" | awk '{printf ("%.3f\n",$1/$2)}')
ave_t=$(echo "${time_total} ${count_c}" | awk '{printf ("%.3f\n",$1/$2)}')

printf "${format}" Average "" ${ave_c} ${ave_s} ${ave_t}
