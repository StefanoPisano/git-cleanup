#!/bin/bash
baseDir="/home/stedev"
baseScriptDir="$baseDir/Documents/Scripts/RepoCleaner"
prjDir="$baseDir/IdeaProjects/my-project"
timestamp=`date "+%Y%m%d_%H%M"`
filteredBranches="(master|develop|HEAD)"

EmptyLine() {
    echo ""
}

Divider() {
    EmptyLine
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
    EmptyLine
}

CreateDirIfNotExists() {
    echo "Looking for directory $1..."
    EmptyLine

    if [ -d "$1" ] 
        then
            echo "Directory already exists, nothind done here."
        else
            echo "Directory does not exists, creating new one."
            mkdir $1
        fi
}

ListMergedBranchesToFile() {
    Divider
    echo "Moving to $prjDir and getting merged branches"

    cd $prjDir
    git branch -r --merged origin/master > $baseScriptDir/$1/original-report.txt
}


EmptyFileIfExists() {
    Divider
    echo "Clearing final report..."

    > $baseScriptDir/$1/final-report.txt
}

FilterReportToFile() {
    Divider 
    echo "Filtering pre-final report. Excluding $filteredBranches from final report..."

    grep -vwE $filteredBranches $baseScriptDir/$1/original-report.txt > $baseScriptDir/$1/pre-final-report.txt
}

WriteFinalReport() {
    Divider 
    echo "Writing final report..."

     while IFS= read -r line; do 
        row=$(echo $line | tr "" "\n")
        origin="$(cut -d'/' -f1 <<<"$line")"
        branch="$(cut -d'/' -f2 <<<"$line")"
        echo git push $origin --delete $branch >> $baseScriptDir/$1/final-report.txt
    done <$baseScriptDir/$1/pre-final-report.txt

    EmptyLine
    echo "Completed."
}

CreateDirIfNotExists "$timestamp"
ListMergedBranchesToFile "$timestamp"
FilterReportToFile "$timestamp"
EmptyFileIfExists "$timestamp"
WriteFinalReport "$timestamp"

