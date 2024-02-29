#!/bin/bash

# Check if directory path is provided as parameter
if [ $# -eq 1 ]; then
    # Assign directory path to a variable
    dir="$1"
else
    # Use the current directory if no parameter is provided
    dir="$(pwd)"
fi

# Check if the directory exists
if [ ! -d "$dir" ]; then
    echo "Error: Directory '$dir' not found."
    exit 1
fi

total_duration=0

# Loop through all .mp4 files in the current directory
for file in "$dir"/*.mp4; do
    # Extract duration of each video file using ffmpeg
    duration=$(ffmpeg -i "$file" 2>&1 | awk '/Duration/ {print $2}' | sed 's/,//g')

    # Calculate duration in seconds
    seconds=$(echo "$duration" | awk -F: '{print ($1*3600) + ($2*60) + int($3)}')

    # Add duration to total duration
    total_duration=$((total_duration + seconds))
done

# Convert total duration to HH:MM:SS format
hours=$((total_duration / 3600))
minutes=$((total_duration % 3600 / 60))
seconds=$((total_duration % 60))

# Print total duration
printf "Total duration of all videos: %02d:%02d:%02d\n" "$hours" "$minutes" "$seconds"
