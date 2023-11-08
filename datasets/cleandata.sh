#!/bin/bash 

marktime(){
MESSAGE=$1

echo `date +%s.%N` $MESSAGE >> perf.log

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
  line="$(echo "$line" | sed -e 's/^[[:space:]]*//;s/[[:space:]]*$//;s/;;/;/g')"

  marktime "startregexp"
  # Checking if the line contains valid data like bellow format otherwise -(skip headers and empty lines)
  if [[ ! "$line" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2} ]]; then
    return
  fi
  marktime "endregexp"

  # Extract the required fields as columns (Date, Time, and Temperature)
  date="$(echo "$line" | cut -d ';' -f 1)"
  time="$(echo "$line" | cut -d ';' -f 2)"
  temperature="$(echo "$line" | cut -d ';' -f 3)"

  # Print the processed data in CSV format
  echo "$date,$time,$temperature"
}
# Process the input file and save the results to the output file
cat "$temp_file"  |while IFS= read -r line; do
  marktime "startwhile"
  process_data_line "$line"
  marktime "endwhile"
done > "$output_file"

