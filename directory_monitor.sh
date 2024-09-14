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
output_unknown_dir="${output_root_dir}/unknown"

mkdir -p "$output_video_dir"
mkdir -p "$output_image_dir"
mkdir -p "$output_audio_dir"
mkdir -p "$output_unknown_dir"

# Monitor the input directory for new files
# -m: Monitor mode, keeps inotifywait running continuously
# -e create: triggers on file creation events 
# -e moved_to: triggers on file moved into folder events
# -e close_write: triggers on file copied to the folder
 # 'read -r' processes output from inotifywait without / as escape characters
    #   - 'path': the directory 
    #   - 'action': the type of event
    #   - 'file': the name of the file
inotifywait -m "$input_dir" -e create -e moved_to -e close_write |
while read -r path action file; do

    # Get the mime type of the file
    file_type=$(file --mime-type -b "${path}${file}" | grep -oE '^(video|image|audio)')

    case $file_type in
        "video")
            mv "${path}${file}" "$output_video_dir" 2>/dev/null
            echo "Moved $file to $output_video_dir"
            ;;
        "image")
            mv "${path}${file}" "$output_image_dir" 2>/dev/null
            echo "Moved $file to $output_image_dir"
            ;;
        "audio")
            mv "${path}${file}" "$output_audio_dir" 2>/dev/null
            echo "Moved $file to $output_audio_dir"
            ;;
        *)
            mv "${path}${file}" "$output_unknown_dir" 2>/dev/null
            echo "Unknown file type: moved $file to $output_unknown_dir"
            ;;
    esac
done