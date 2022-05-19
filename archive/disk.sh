#! /usr/bin/env bash

##
#  Welcome message. Execute this script in ~/.zprofile so it runs
#  before everything that gets loaded in ~/.zshrc.
#
#  Dependencies: figlet (brew install figlet)
##

## Example output ##################################################################
#                                                                                  #
#  __        __   _                             __  __ _      _                _   #
#  \ \      / /__| | ___ ___  _ __ ___   ___   |  \/  (_) ___| |__   __ _  ___| |  #
#   \ \ /\ / / _ \ |/ __/ _ \| '_ ` _ \ / _ \  | |\/| | |/ __| '_ \ / _` |/ _ \ |  #
#    \ V  V /  __/ | (_| (_) | | | | | |  __/  | |  | | | (__| | | | (_| |  __/ |  #
#     \_/\_/ \___|_|\___\___/|_| |_| |_|\___|  |_|  |_|_|\___|_| |_|\__,_|\___|_|  #
#                                                                                  #
#                                   /dev/disk1s1                                   #
#                                       121G                                       #
#                31G Used                                  73G Free                #
#                --------------------------------------------------                #
#                31%                                            69%                #
#                                                                                  #
#                                    CPU: 49.4%                                    #
#                                    MEM: 51.5%                                    #
#                                                                                  #
####################################################################################


# Color scheme.
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
NORMAL=$(tput sgr0)


# Returns: round(number / 2).
function round_half {
	local n="$1"
	# printf "%.0f" $(bc -l <<< "$1 / 2") # <- This is inconsistent.
	echo "$(( n / 2 ))" # Round down instead.
}

# Number of columns in current device window.
window_size=`stty -a <"$(tty)" | head -n1 | awk '{ print $6 }'`

# Prints n spaces.
function print_block_spaces {
	local n="${1-50}"
	printf '%0.s ' $(seq 1 $(round_half $((window_size - n))))
}


# Data.
input_disk_name='/disk1s1' # disk name to search for: e.g. /disk1s1
data="`df -H | grep "$input_disk_name" | awk '{ print $1,$2,$3,$4,$5 }'`" # raw data.

# Usage strings.
disk_name="`echo $data | awk '{print $1}'`" # full disk name: e.g. /dev/disk1s1
disk_size_string="`echo $data | awk '{print $2}'`" # disk size: e.g. 121G
used_space_string="`echo $data | awk '{print $3}'`" # used space: e.g. 31G
free_space_string="`echo $data | awk '{print $4}'`" # free space: e.g. 73G

# percent used space and free space: e.g. 31 and 69.
percent_used_space="`echo $data | awk '{print $5}' | cut -d'%' -f1`"
percent_free_space="$((100 - percent_used_space))"

# Number of ticks.
n_red_ticks="`round_half $percent_used_space`"
n_green_ticks="$((50 - n_red_ticks))"

# Padding.
used_space_line_padding="$((${#used_space_string} + 5))"
percent_used_space_line_padding="$((${#percent_used_space} + 1))"

# Padding in printf format.
used_space_line_pformat="%s %$((49 - used_space_line_padding))s\n"
percent_used_space_line_pformat="%s %$((49 - percent_used_space_line_padding))s\n"



## Constructing each line.
# .... /dev/disk1s1 ....
disk_name_line=`print_block_spaces ${#disk_name} && echo "$disk_name"`

# .... 121G ....
disk_size_line=`print_block_spaces ${#disk_size_string} && echo "$disk_size_string"`

# .... 31G Used .... 73G Free ....
used_space_line=`print_block_spaces &&
	printf "$used_space_line_pformat" "$used_space_string Used" "$free_space_string Free"`

# .... ---- -------- ....
ticks_line=`print_block_spaces && 
	echo -n "$RED" && printf '%0.s-' $(seq 1 $n_red_ticks) &&
	echo -n "$GREEN" && printf '%0.s-' $(seq 1 $n_green_ticks) &&
	echo "$NORMAL"`

# .... 31% .... 69% ....
percent_used_space_line=`print_block_spaces &&
	printf "$percent_used_space_line_pformat" "${percent_used_space}%" "${percent_free_space}%"`



# Returns cpu and memory usage.
function get_cpu_mem {
	ps -A -o %cpu,%mem | 
	awk '{ cpu += $1; mem += $2} END { print cpu" "mem }'
}
cpu_data="`get_cpu_mem`"
cpu_usage="`echo $cpu_data | awk '{ printf("%.1f", $1) }'`%"
cpu_usage_length="${#cpu_usage}"
mem_usage="`echo $cpu_data | awk '{ printf("%.1f", $2) }'`%"
mem_usage_length="${#mem_usage}"
cpu_padding="$((cpu_usage_length > mem_usage_length ? cpu_usage_length : mem_usage_length))"

cpu_usage_string=`printf "CPU: %*s" $cpu_padding "$cpu_usage"`
mem_usage_string=`printf "MEM: %*s" $cpu_padding "$mem_usage"`


# .... CPU: 22.6% ....
# .... MEM: 58.0% ....
cpu_line=`print_block_spaces ${#cpu_usage_string} && echo "$cpu_usage_string"`
memory_line=`print_block_spaces ${#mem_usage_string} && echo "$mem_usage_string"`



# .... WELCOME MICHAEL | SYSTEM STATUS ....
message="${1:-System Status}"
figlet -w "$window_size" -c "$message" #| lolcat

# Print all the messages!
echo "$disk_name_line"
echo "$disk_size_line"
echo "$used_space_line"
echo "$ticks_line"
echo "$percent_used_space_line"
echo
echo "$cpu_line"
echo "$memory_line"
