#!/bin/bash 

checkdiff(){
DIFF_MESSAGE=$1
DIFF_START=$2
DIFF_END=$3
DIFF_RESULT=$(bc <<< $DIFF_END-$DIFF_START)
echo $DIFF_MESSAGE: $DIFF_RESULT >> perf.log

}

# putting our input and output file names into two variables
input_file="smhi-opendata_1_53430_20231007_155558_Lund.csv"
output_file="processed_data.csv"
temp_file="temp_file.csv"
# This code will check if the input file exists
if [ ! -f "$input_file" ]; then
    echo "Input file not found: $input_file"
    exit 1
fi

# tail is used to skip the first 13 lines and save the rest lines to a temporary file
tail -n +14 "$input_file" > "$temp_file"


# Function to process and clean a line of data
process_data_line() {
  line="$1"
  # Removing if any leading spaces and extra semicolons are present
  STARTSED=`date +%s.%N`
  line="$(echo "$line" | sed -e 's/^[[:space:]]*//;s/[[:space:]]*$//;s/;;/;/g')"
  ENDSED=`date +%s.%N`
  checkdiff "seddiff" $STARTSED $ENDSED

  STARTREGEXP=`date +%s.%N` 
  # Checking if the line contains valid data like bellow format otherwise -(skip headers and empty lines)
  if [[ ! "$line" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2} ]]; then
    return
  fi
  ENDREGEXP=`date +%s.%N`
  checkdiff "regexpdiff" $STARTREGEXP $ENDREGEXP

  # Extract the required fields as columns (Date, Time, and Temperature)
  date="$(echo "$line" | cut -d ';' -f 1)"
  time="$(echo "$line" | cut -d ';' -f 2)"
  temperature="$(echo "$line" | cut -d ';' -f 3)"

  # Print the processed data in CSV format
  echo "$date,$time,$temperature"
}
# Process the input file and save the results to the output file
cat "$temp_file"  |while IFS= read -r line; do
  STARTWHILE=`date +%s.%N`
  process_data_line "$line"
  ENDWHILE=`date +%s.%N`
  checkdiff "whilediff" $STARTWHILE $ENDWHILE
done > "$output_file"

