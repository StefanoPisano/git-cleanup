# repo-cleaner
Simple shell script to clean GIT repositories

## Install
1. Clone the repository and get the script
2. Open it with your favourite text editor (Notepad++, Notepad, IDEA or whatever you want)
3. Set your parameters (directories, origin names, filtered branches)
4. Launch it
5. Get results in your final-report.txt file (created inside the reports folder) and launch them into the terminal

## Personalization
`baseDir` home directory for your user <br>
`baseScriptDir` directory where the script has been saved <br>
`prjDir` directory of your GIT project <br>
`timestamp` timestamp used to generate reports folders, by default it will generate something like that: 20230123_1115 <br>
`filteredBranches` branch to exclude from the final report

## Functions
`CreateDirIfNotExists()` It will look for a directory named with the current timestamp, if not exists it will create it <br>
`ListMergedBranchesToFile()` Create a file named original-report.txt with the full list of branches merged inside master <br>
`FilterReportToFile()` Based on the original-report it filters the branches you indicated on the `filteredBranches` variable <br>
`EmptyFileIfExists()` If the final-report.txt file already exists this function will clear it <br>
`WriteFinalReport()` Iterate over the pre-final-report.txt and generates git commands to delete the remote branches. It doesn't delete anything, it will only generates the commands

## Automatic clean up
You could also execute the script passing `execute` as argument, in that case the script will execute all commands inside the final-report.txt file. **at your own risk :D**
