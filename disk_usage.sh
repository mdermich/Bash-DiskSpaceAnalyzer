#!/bin/bash

#We initialize all command option flags to false. Each time the user enters an option the respective flag gets set to true
optionD=false
optionH=false
optionS=false
optionR=false
optionF=false
optionA=false
optionO=false

#We go through the otions entered by the user
while getopts ":d:hsr:fao:" option; do
	case "${option}" in
		d)
			optionD=true
			argumentD=$OPTARG
			;;
		h)	
			optionH=true
			;;
		s)
			optionS=true
			;;
		r)
			optionR=true
			argumentR=$OPTARG
			;;
		f)
			optionF=true
			;;
		a)
			optionA=true
			;;
		o)
			optionO=true
			argumentO=$OPTARG
			;;
		:)
			echo "The option $OPTARG requires an argument"
			exit 1
			;;
		\?)
			echo "$OPTARG : Invalid option"
			exit 1
			;;
	esac
done

#We check the format of the arguments entered by the user (if any) afetr the options -d, -r and -o
checkArguments(){
	checkArgumentD
	checkArgumentR
	checkArgumentO
}

checkArgumentD(){
	#if the user used the option -d
	if [[ "$optionD" = true ]] ; then
		#we check if the user entered an argument after the option
		#if the user forgot the argument. Ie : bash main -d -o
		if [[ $argumentD =~ -. ]] ; then
			echo "The option -d requires an argument"
			exit 1
		#if the user entered the argument
		else
			#We check if the directory exists
			checkDirectoryExists
		fi
	fi
}

checkArgumentR(){
	#if the user used the option -d and forgot to enter an argument afterward. Ie : bash main -r -s
	if [[ "$optionR" = true && $argumentR =~ -. ]] ; then
		echo "The option -r requires an argument"
		exit 1
	fi
}

checkArgumentO(){
	#if the user used the option -d and forgot to enter an argument afterward. Ie : bash main -o -s
	if [[ "$optionO" = true && $argumentO =~ -. ]] ; then
		echo "The option -o requires an argument"
		exit 1
	fi
}

#check if the directory entered exists
checkDirectoryExists(){
	if [[ ! -d $argumentD ]] ; then
		echo "$argumentD : No such directory"
		exit 1
	#if the directory exists
	else
		#we need to check if the directory requires permissions
		checkDirectoryPermissions
	fi
}

checkDirectoryPermissions(){
	#Go through the directories inside the directory entered
	for d in $(find $argumentD -maxdepth 1 2> /dev/null)
	do
		#check if the directory is readable
	  	if ! [[ -r $d ]] ; then
			echo "The directory '$argumentD' is not readable : Permission denied"
			exit 1
		fi
	done
	
}

main(){
	#Initialize some parts of the final command
	command_directory=""
	command=""
	command_root="du"
	command_depth="-d 1"
	command="$command_root"
	
	#check if user entered options
	checkOptions
	
	echo 'Size	Folder'
	
	#Execute the command
	eval $command
}

checkOptions(){
	checkOptionD
	checkOptionR
	checkOptionF
	checkOptionH
	checkOptionA
	checkOptionS
	checkOptionO
}

checkOptionF(){
	if [ "$optionF" = true ] ; then
		command_include_files="-a"
		command="$command $command_include_files"
	fi
}

checkOptionH(){
	if [ "$optionH" = true ] ; then
		command_human_readable="-h"
		command="$command $command_human_readable"	
	fi
}

checkOptionA(){
	if [ "$optionA" = false ] ; then
		command_exclude_hidden="--exclude '.*'"
		command="$command $command_exclude_hidden"
	fi
}

checkOptionD(){
	if [ "$optionD" = true ] ; then
		command_directory="$argumentD"
	else
		command_directory=$PWD
	fi
	#command="$command $command_directory"
}

checkOptionS(){
	if [ "$optionS" = true ] ; then
		command_sort="sort -rh"
		command="$command | $command_sort"
	fi
}

checkOptionR(){
	if [ "$optionR" = true ] ; then
		command_regex="find $command_directory -maxdepth 1 -regex '$command_directory/$argumentR'"
		command_depth="-d 0"
		command="$command_regex | xargs $command $command_depth"
	else 
		command="$command $command_depth $command_directory"
	fi
}

checkOptionO(){
	if [ "$optionO" = true ] ; then
		currentDate="date +'%Y-%m-%d %T'"
		eval "$currentDate >> $argumentO"
		command="$command >> $argumentO"
	fi
}

#We check the arguments entered first
checkArguments

#Then we build the command and run it
main






			
			
			
			
