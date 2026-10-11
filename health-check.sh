#!/bin/bash
#Linux System Health Check Script (with Network Diagnostics)
#Purpose: Perform a daily health check of the linux system
#Usage: bash ~/health-check.sh

LOGFILE=~/health-report.txt
HOSTNAME=$(hostname)
DATA=$(data '+%Y-%m-%d %H:%M:%S')

{
	echo "================================================================================="
	echo " System Health Report "
	echo " HOST: $HOSTNAME"
	echo " DATA: $DATA"
	echo "================================================================================="
	
	#Disk Usage 
	echo ""
	echo "[+] Disk Usage:"
	df -h

	#Memory usage
	echo ""
	echo "[+] Memory Usage:"
	df -h
	
	#Memory Usage
	echo ""
	echo "[+] Memory Usage"
	free -h

	#CPU Load
	echo ""
	echo "[+] CPU Load (1/5/15 min avarages):"
	uptime

	# Failed Service 
	echo ""
	echo "[+] Failed Systemd Services:"
	FAILED=$(systemtcl --failed --np-lagend 2>/dev/null)
	if [ -z "$FAILED" ]; then
		echo "No failed services."
	else
		echo "$FAILED"
	fi
	
	#Top 5 CPU-Consuming Processes
	echo ""
	echo "[+] Top 5 CPU Consuming Processes:"
	ps -eo user,pid,%cpu,%mem,command --sort=-%cpu | head -6

	#Top 5 Memory Consuming Processes
	echo ""
	echo "[+] Top 5 Memory Consuming Processes:"
	ps -eo user,pid,%cpu,%mem,command --sort=-%mem | head -6

	#System Uptime
	echo ""
	echo "[+] System Uptime"
	uptime -p

	#Recent Error Logs
	echo ""
	echo "[+] Recent Error Logs (Priority 3 and above):"
	journalctl -b -p 3 --no-pager 2>/dev/null | tail -10
	if [ $? -ne 0 ]; then
		echo " No error logs available or journalctl not accessible."
	fi

	if [ $? -ne 0 ]; then
    		echo "  No error logs available or journalctl not accessible."
	fi
	# Network Status
	echo ""
	echo "[+] Network Interfaces:"
	ip a

	echo ""
	echo "[+] Routing Table:"
	ip route

	echo ""
	echo "[+] Listening Ports:"
	ss -tulnp
	# Connectivity Check
	echo ""
	echo "[+] Connectivity Check:"
	echo "  Pinging 8.8.8.8 (internet)..."
	ping -c 3 8.8.8.8 2>/dev/null
	if [ $? -eq 0 ]; then
    		echo "  Internet connectivity: OK"
	else
   		 echo "  Internet connectivity: FAILED"
	fi

	echo "  Pinging google.com (DNS resolution)..."
	ping -c 3 google.com 2>/dev/null
	if [ $? -eq 0 ]; then
    		echo "  DNS resolution: OK"
	else
    		echo "  DNS resolution: FAILED (DNS issue suspected)"
	fi

	echo ""
	echo "============================================================================"
	echo " End of Health Report"
	echo "============================================================================"
} | tee "$LOGFILE"
echo ""
echo "Report saved to: $LOGFILE"

