#!/bin/bash
#==================================================================================
#	File: cleanup.sh
#
#	Usage: [sudo] ./cleanup.sh [-h help] [-v verbose]
#
#	Author: Ali Alshawish
#	Version: 1.0
#	Created: 28.05.2022
#	Description: TMH  Homework Task1
#		- Starting in the /opt directory, locate all directories which 
#		  contain a file called .prune-enable
#		- In those directories, delete any files named crash.dump
#		- In those directories, for any file having the suffix ".log", 
#		  if the file is larger than one megabyte, replace the file with 
#		  a file containing only the last 20,000 lines.
#
#==================================================================================

# initilization
START="/opt"
FN1=".prune-enable"
FN2="crash.dump"
FN3="*.log"
NL=20000

VERBOSE=0

while getopts "hv" flag; do
        case ${flag} in
                h ) echo "Usage: [sudo] $0 [-h help] [-v verbose]"
                ;;
                v ) VERBOSE=1
                ;;
                \? ) echo "Invalid input: Try $0 -h for more information"
                ;;
        esac
done

# Provide output details if the verbose mode is activated 
function record(){
        if [[ $VERBOSE -eq 1 ]]; then
                echo "$1"
        fi
}

# Task1 solution:
# - Starting from /opt, locate all directories containing .prune-enable
# - Potential problem: unusual charachters in filenames such as whitespaces, newlines, \
#   or tab can lead to incorrect bahaviour of the program.
# - To ensure safety, process substition is used to temporarly store the `find` results \
#   delimitered by NULL using the flag `-print0`` in a file and direct it as STDIN to the while loop
# - Delete the default delimiters, i.e. IFS=' \t\n', between fields used by `read` command when \
#   splitting a single line of input into fields.
# - Additionally, `-r` flag disables backslash interprtation and `-d` will use NULL as sperator between \
#   lines while reading from the temporary file

while IFS= read -r -d '' prunefile; do
        dir=$(dirname "${prunefile}") 
        # Delete any files named crash.dump in the found directories 
        DUMP=$dir"/"$FN2
        if [[ -e $DUMP ]]; then 
                rm -f "$DUMP" && \
                record "[deleted] $DUMP ..."
        fi 
        
        # replace .log files of +1M size with a file containing only the last 20,000 lines.
        while IFS= read -r -d '' log; do
                # First option *in-place* replacement 
                # Before replacement, make sure the file has already more than 20k lines
                numl=$(wc -l "$log" | cut -d " " -f 1) 
                if [[ $numl -gt $NL ]]; then
                        sed -i -e ''$(($numl - $NL + 1))',$! d' "$log" && \
                        record "[truncated] #lines = $(wc -l "$log") ..."
                fi    
                # Second possilbe option use a temp file and `mv` command
                #tail -n $NL $log > $log$"-tmp" && mv $log$"-tmp" $log
        done < <(find "$dir" -name $FN3 -type f -size +1c -maxdepth 1 -print0) # -maxdepth 1 limit the search for .log files in the current $dir directory based on the task description
done < <(find $START -name $FN1 -type f -print0)