#!/bin/bash
# Path to netcat
NC="nc" # !MAYBE CHANGE TO YOUR PATH TO NETCAT, e.g. -> "/usr/bin/nc"!
# Where are we sending messages from / to?
SOURCES=("192.168.190.2" "192.168.190.3" "192.168.190.4" "192.168.190.5" "192.168.190.6" "192.168.190.7" "192.168.190.8")
DEST_IP="10.0.2.15" # !CHANGE TO YOUR IP ADDRESS!
# List of messages.
MESSAGES=(
  "System overload detected"
  "Network connection lost"
  "Security breach detected"
  "Disk space running low"
  "Service restarted successfully"
  "Access granted to user"
  "Invalid login attempt detected"
  "High CPU utilization detected"
  "File not found error"
  "Backup completed"
  "Database connection established"
  "Critical error: application crashed"
  "Unauthorized access attempt"
  "Database table updated"
  "Service outage detected"
  "Configuration file modified"
)

# How long to wait in between sending messages.
SLEEP_SECS=1
# How many message to send at a time.
COUNT=1
# What priority?  
#             emergency   alert   critical   error   warning   notice   info   debug
# kernel              0       1          2       3         4        5      6       7
# user                8       9         10      11        12       13     14      15
# mail               16      17         18      19        20       21     22      23
# system             24      25         26      27        28       29     30      31
# security           32      33         34      35        36       37     38      39
# syslog             40      41         42      43        44       45     46      47
# lpd                48      49         50      51        52       53     54      55
# nntp               56      57         58      59        60       61     62      63
# uucp               64      65         66      67        68       69     70      71
# time               72      73         74      75        76       77     78      79
# security           80      81         82      83        84       85     86      87
# ftpd               88      89         90      91        92       93     94      95
# ntpd               96      97         98      99       100      101    102     103
# logaudit          104     105        106     107       108      109    110     111
# logalert          112     113        114     115       116      117    118     119
# clock             120     121        122     123       124      125    126     127
# local0            128     129        130     131       132      133    134     135
# local1            136     137        138     139       140      141    142     143
# local2            144     145        146     147       148      149    150     151
# local3            152     153        154     155       156      157    158     159
# local4            160     161        162     163       164      165    166     167
# local5            168     169        170     171       172      173    174     175
# local6            176     177        178     179       180      181    182     183
# local7            184     185        186     187       188      189    190     191

# PRI=(Facility Value * 8) + Severity Value
FACILITIES=("kernel" "user" "mail" "system daemons" "security/authorization messages" "internally by syslogd" "line printer subsystem" "network news subsystem" "UUCP subsystem" "clock daemon" "security/authorization messages" "FTP daemon" "NTP subsystem" "log audit" "log alert" "clock daemon")
SEVERITIES=("Emergency" "Alert" "Critical" "Error" "Warning" "Notice" "Informational" "Debug")

# loop until user stops the program
while [ 1 ]
do
	# for loop for the number of messages to send each time
	for i in $(seq 1 $COUNT)
	do
		# Picks a random syslog message from the list.
		RANDOM_MESSAGE=${MESSAGES[$RANDOM % ${#MESSAGES[@]} ]}
		SOURCE=${SOURCES[$RANDOM % ${#SOURCES[@]} ]}
		# Picks a random facility and severity from the lists.
		FACILITY_INDEX=$((RANDOM % ${#FACILITIES[@]}))
		SEVERITIY_INDEX=$((RANDOM % ${#SEVERITIES[@]}))
		FACILITY=${FACILITIES[$FACILITY_INDEX]}
		LEVEL=${SEVERITIES[$SEVERITIY_INDEX]}
		# Calculates Priority Value.
		PRIORITY=$((8 * $FACILITY_INDEX + $SEVERITIY_INDEX))

		# Send the message to log
		$NC $DEST_IP -u 514 -w 0 <<< "<$PRIORITY>`env LANG=us_US.UTF-8 date "+%b %d %H:%M:%S"` $SOURCE [$FACILITY.$LEVEL] service: $RANDOM_MESSAGE FV:$FACILITY_INDEX SV:$SEVERITIY_INDEX PRI->$PRIORITY"

		# write the message to the shell (for debugging)
		echo $NC $DEST_IP -u 514 -w 0 "<$PRIORITY>`env LANG=us_US.UTF-8 date "+%b %d %H:%M:%S"` $SOURCE [$FACILITY.$LEVEL] service: $RANDOM_MESSAGE FV:$FACILITY_INDEX SV:$SEVERITIY_INDEX PRI->$PRIORITY"
	done
	# wait for a number of seconds and do nothing
	sleep $SLEEP_SECS
done
