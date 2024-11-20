#!/bin/bash

# Configuration
current_path=$(pwd)          # The current working directory where the script is executed
project_dir="$HOME/path-to-my-git-project"  # Path to the project directory
timestamp=$(date "+%Y%m%d_%H%M")  # Timestamp for creating unique folders and files
branches_to_filter="master|master_old|develop|HEAD|main"  # Branches to exclude from the final report
main_branch="main"  # The main branch to check for merged branches

# Utility functions

# Prints an empty line for better readability in the output
empty_line() {
    echo ""
}

# Prints a divider line to separate sections in the output
divider() {
    empty_line
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
    empty_line
}

# Prints messages with step numbers in bold
bold_step() {
    echo -e "\033[1mStep $1:\033[0m $2"
}

# Prints INFO messages in azure (light blue)
info_message() {
    echo -e "\033[96mINFO: $1\033[0m"
}

# Prints ERROR messages in red
error_message() {
    echo -e "\033[91mERROR: $1\033[0m"
}

# Prints Step 8 description in green
green_step() {
    echo -e "\033[1mStep $1:\033[32m $2\033[0m"
}

# Fetches the latest changes from the remote repository
fetch() {
    bold_step 1 "Fetching updates from the remote repository..."
    cd "$project_dir" || { error_message "Could not change to project directory: $project_dir"; exit 1; }
    git prune
    git fetch
}

# Creates a directory if it does not already exist
create_dir_if_not_exists() {
    local dir="$1"
    bold_step 2 "Checking for directory: $dir..."

    cd "$current_path" || { error_message "Could not change to script directory: $current_path"; exit 1; }

    if [ -d "$dir" ]; then
        info_message "Directory already exists: $dir"
    else
        info_message "Directory does not exist. Creating: $dir"
        mkdir "$dir"
    fi

    empty_line
}

# Lists all branches merged into the specified main branch and saves them to a file
list_merged_branches_to_file() {
    bold_step 3 "Listing branches merged into $main_branch..."

    cd "$project_dir" || { error_message "Could not change to project directory: $project_dir"; exit 1; }
    git branch -r --merged origin/"$main_branch" > "$current_path/$1/original-report.txt"
}

# Clears the final report file if it already exists
empty_file_if_exists() {
    bold_step 4 "Clearing contents of final report file..."
    : > "$current_path/$1/final-report.txt"
}

# Filters out branches based on predefined patterns and writes to a temporary file
filter_report_to_file() {
    bold_step 5 "Filtering branches to exclude: $branches_to_filter"
    grep -vwE "$branches_to_filter" "$current_path/$1/original-report.txt" > "$current_path/$1/pre-final-report-tmp.txt"
}

# Removes branches related to releases from the filtered report
remove_release_branches() {
    bold_step 6 "Excluding release branches from the report..."
    grep -v "release" "$current_path/$1/pre-final-report-tmp.txt" > "$current_path/$1/pre-final-report.txt"
}

# Deletes the temporary file used for intermediate filtering
remove_tmp_report() {
    bold_step 7 "Removing temporary files..."
    rm "$current_path/$1/pre-final-report-tmp.txt"
}

# Generates a final report with git commands to delete branches
write_final_report() {
    bold_step 8 "Generating final report with delete commands..."

    while IFS= read -r line; do
        origin=$(echo "$line" | cut -d'/' -f1)
        feature=$(echo "$line" | cut -d'/' -f2)
        branch=$(echo "$line" | cut -d'/' -f3)
        echo "git push $origin --delete $feature/$branch" >> "$current_path/$1/final-report.txt"
    done < "$current_path/$1/pre-final-report.txt"

    empty_line
    green_step 8 "Final report generated successfully."
    empty_line
}

# Main script execution
divider
fetch
create_dir_if_not_exists "$timestamp"
list_merged_branches_to_file "$timestamp"
filter_report_to_file "$timestamp"
remove_release_branches "$timestamp"
remove_tmp_report "$timestamp"
empty_file_if_exists "$timestamp"
write_final_report "$timestamp"

# Execute the cleanup commands if "execute" is passed as an argument
if [ "$1" == "execute" ]; then
    bold_step 9 "Executing cleanup commands from the $timestamp folder..."
    empty_line
    cd "$timestamp" || { error_message "Could not change to timestamp directory: $timestamp"; exit 1; }
    sh final-report.txt
    bold_step 9 "Cleanup executed successfully."
else
    info_message "Cleanup execution skipped."
fi
