# Disk Space Analyzer
A tool that analizes the used disk storage of the sub-folders of the current folder in your machine. It can be executed with or without arguments. The arguments are as follows :
* -d <folder> : runs the program on a specific folder.
* -h : sets the output in a human readable format (Ko, Mo, Go ...).
* -s : will sort the output in reverse order.
* -r <regex> : runs the program only on the elements that correspond the regex passed as a parameter. 
* -f : will run the program on files + sub-folders inside the targeted folder.
* -a : will run the program also on cached files & folders.
* -o <file> : returns the output in file + date & hour of execution.

## Installation
* Clone the repo :
``` bash
git clone https://github.com/mdermich/Bash-DiskSpaceAnalyzer.git
```
* Run the program :
``` bash
bash disk_usage.sh [arguments]
```
  
  
  
  
