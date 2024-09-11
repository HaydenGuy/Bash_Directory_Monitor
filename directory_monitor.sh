#!/bin/bash

input_dir="/home/hayden/Downloads/monitor"
output_dir="/home/hayden/Downloads/output"

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
