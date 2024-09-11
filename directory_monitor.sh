#!/bin/bash

# Resolve the absolute path of the currently executing script
# "$0" refers to the script's filename or relative path
# realpath "$0" converts this to an absolute path
# dirname extracts the directory part from this absolute path
script_dir="$(dirname "$(realpath "$0")")"

# Find the config file in the script directory
config_file="$script_dir/config.conf"

# Load the variables in the config file
source "$config_file"

# Set variables based on the config file
input_dir="$input_dir"
output_video_dir="${output_root_dir}/video"
output_image_dir="${output_root_dir}/image"
output_audio_dir="${output_root_dir}/audio"

mkdir -p "$output_video_dir"
mkdir -p "$output_image_dir"
mkdir -p "$output_audio_dir"

# Monitor the input directory for new file creation events
# -m: Monitor mode, keeps inotifywait running continuously
# -e create: Only triggers on file creation events in the monitored directory
inotifywait -m "$input_dir" -e create |
while read path action file; do
    # 'read' command processes output from inotifywait
    #   - 'path': the directory where the event occurred
    #   - 'action': the type of event (in this case, "CREATE")
    #   - 'file': the name of the newly created file
    echo "New file detected: $file in directory $path"
    
    mv "$path/$file" "$output_dir/"
    echo "Moved $file to $output_dir/"
done
