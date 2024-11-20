## Git Cleanup

### Overview
This Bash script automates the process of cleaning up remote branches in a Git repository. It identifies branches merged into the main branch, filters them based on predefined patterns, and generates a report with commands to delete them. If executed with the `execute` argument, it performs the branch cleanup automatically.

---

### Features
- **Fetch Updates:** Retrieves the latest changes from the remote repository.
- **Merged Branch Report:** Generates a list of branches merged into the main branch.
- **Filtering:** Excludes specific branches and patterns (e.g., `master`, `main`, `HEAD`, `develop`, `release`).
- **Command Generation:** Prepares `git push --delete` commands for branch cleanup.
- **Execution Mode:** Optionally executes the cleanup commands.

---

### Prerequisites
1. Ensure Git is installed and configured on your system.
2. Verify that you have appropriate permissions to delete branches on the remote repository.
3. Update the `project_dir` variable in the script to point to your Git project directory.

---

### Usage
1. **Clone or Download the Script**  
   Save the script to your desired location and make it executable:
   ```bash
   chmod +x git-cleanup.sh
   ```

2. **Run the Script**  
   Execute the script without arguments to generate a report only:
   ```bash
   ./git-cleanup.sh
   ```

   To generate the report and delete branches:
   ```bash
   ./git-cleanup.sh execute
   ```

---

### Script Workflow
1. **Fetch Updates:** Updates local information from the remote repository.
2. **Create Timestamped Directory:** Organizes output files in a uniquely named folder.
3. **List Merged Branches:** Identifies branches merged into the main branch (`main` by default).
4. **Filter Branches:** Excludes unwanted branches and release-related branches.
5. **Generate Cleanup Commands:** Writes `git push --delete` commands to a final report.
6. **Execute Commands (Optional):** Deletes branches if `execute` is passed as an argument.

---

### Output
- **`original-report.txt`:** Full list of merged branches.
- **`pre-final-report.txt`:** Filtered list of branches.
- **`final-report.txt`:** Commands to delete branches.

---

### Configuration
You can customize the following variables:
- **`project_dir`:** Path to your Git project.
- **`branches_to_filter`:** Branch patterns to exclude.
- **`main_branch`:** The main branch used for comparison (default: `main`).

---

### Error Handling
- The script will display error messages in red if it encounters issues like missing directories or commands failing.
- Each step is logged with a descriptive message for better traceability.

---

### Example
```bash
# Run script in preview mode (generates report only):
./git-cleanup.sh

# Run script and execute branch cleanup:
./git-cleanup.sh execute
```

---

### Notes
- The script should be run from a directory where it has write permissions.
- Use caution when running with the `execute` option, as it will permanently delete branches.

---

### License
This script is provided "as-is" without any warranty. Use at your own risk.
