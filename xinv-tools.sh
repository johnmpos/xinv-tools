#!/bin/bash

# Create a common structure folder
touch "listener.xinv"
mkdir "src/"

echo "$(pwd)/src" > "listener.xinv"

# Function to handle inotifywait for a directory
monitor_directory() {
    local directory="$1"

    # Check if directory exists
    if [ ! -d "$directory" ]; then
        echo "Warning: Directory $directory does not exist. Skipping."
        return
    fi

    # Create the .backup directory if it does not exist
    BACKUP_DIR="$directory/.backup"
    mkdir -p "$BACKUP_DIR"

    echo "Monitoring changes in $directory..."
    # Monitor create and modify events
    inotifywait -m -e create -e modify "$directory" | while read path action file; do
        case "$action" in
            CREATE)
                echo "File created: $file"
                cp "$directory/$file" "$BACKUP_DIR/${file}.bak"
                ;;
            MODIFY)
                echo "File modified: $file"
                # Check if a backup file already exists for this file
                if [ ! -f "$BACKUP_DIR/${file}.bak" ]; then
                    echo "Error: No initial backup file found for $file. Creating a new backup."
                    cp "$directory/$file" "$BACKUP_DIR/${file}.bak"
                else
                    # Overwrite the backup file with the modified content
                    cp "$directory/$file" "$BACKUP_DIR/${file}.bak"
                fi
                ;;
        esac
    done
}

# Read each directory path from listener.xinv and monitor for file creation and modification
while IFS= read -r directory; do
    # Skip empty lines or lines starting with '#'
    if [[ -z "$directory" || "$directory" == "#"* ]]; then
        continue
    fi

    monitor_directory "$directory" &  # Run inotifywait in the background for each directory
done < "$LISTENER_FILE"

# Wait for all background processes to finish
wait

