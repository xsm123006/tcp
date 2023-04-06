#!/bin/bash

while true; do
	echo "Uuntu & Debian 可用"
    echo "请选择要执行的操作："
    echo "1. 备份并优化TCP参数"
    echo "2. 恢复备份"
    echo "3. 退出"

    read choice

    if [ "$choice" -eq 1 ]; then
        cp /etc/sysctl.conf /etc/sysctl.conf.bak
        cat << EOF >> /etc/sysctl.conf
# TCP参数优化
vm.overcommit_memory = 1
net.core.rmem_default = 26214400
net.core.rmem_max = 67108864
net.ipv4.tcp_rmem = 4096 87380 67108864
net.core.wmem_default = 26214400
net.core.wmem_max = 67108864
net.ipv4.tcp_wmem = 4096 65536 67108864
net.ipv4.tcp_mem = 8388608 12582912 16777216
net.netfilter.nf_conntrack_max = 2097152
net.ipv4.tcp_max_tw_buckets = 2097152
net.nf_conntrack_max = 2097152
net.netfilter.nf_conntrack_tcp_timeout_fin_wait = 15
net.netfilter.nf_conntrack_tcp_timeout_time_wait = 30
net.netfilter.nf_conntrack_tcp_timeout_close_wait = 15
net.netfilter.nf_conntrack_tcp_timeout_established = 300
net.ipv4.tcp_max_syn_backlog = 16384
net.core.netdev_max_backlog = 16384
net.core.somaxconn = 16384
net.ipv4.tcp_syncookies = 1
net.ipv4.ip_local_port_range = 10240 65535
net.ipv4.tcp_slow_start_after_idle = 0
net.ipv4.tcp_sack = 1
net.ipv4.tcp_fastopen = 3
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
net.ipv4.tcp_retries2 = 8
net.core.default_qdisc = fq
net.ipv4.tcp_congestion_control = bbr
EOF
        echo "备份文件到：/etc/sysctl.conf.bak"
        sudo sysctl -p
        echo "TCP参数优化完成并生效"
        exit 0
    elif [ "$choice" -eq 2 ]; then
        if [ -f "/etc/sysctl.conf.bak" ]; then
            cp /etc/sysctl.conf.bak /etc/sysctl.conf
            echo "备份已恢复"
            sudo sysctl -p
            exit 0
        else
            echo "没有备份，无需恢复"
            exit 0
        fi
    elif [ "$choice" -eq 3 ]; then
        exit 0
    else
        echo "输入错误，请重新输入。"
    fi
done
