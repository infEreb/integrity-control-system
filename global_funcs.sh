#!/usr/bin/env bash

function include() {
	[[ -f "$1" ]] && source "$1"
}

include /usr/local/etc/integrity.conf

# directory that would be hashing
#$CONTROL_DIR

# array for hashes
declare -A HASH_ARR
# array for file's data
declare -a FILES_DATA

function LsInfoToArr() {

	local -n files_data=$1
	touch lines.txt
	ls "$CONTROL_DIR" -l | grep -v ^d > lines.txt
	
	LinesToArr files_data < lines.txt		# file's data array
}

function Hashing() {
	
	create_flag=$3
	# array of file's hashes
	local -n hashes=$2
	# array of ls file's info
	local -n info_arr=$1


	for file_data in "${info_arr[@]}" 
	do
		#echo "$file_data"
		file_name=$(echo "$file_data" | awk '{print $NF}')
		file_path=$CONTROL_DIR$file_name  
		
		# save sha of file
		sha=$(echo $(sha1sum < $file_path | awk '{print $1}'))
		# if create_flag is "c" we create .sha1 and .data files
		if [ $create_flag = "c" ]
		then
			# if data file's directory doesn't exist
			if ! [ -d "$DATA_DIR$CONTROL_DIR" ]
			then
				# create one
				mkdir -p "$DATA_DIR$CONTROL_DIR"
			fi
	
			# if sha file's directory doesn't exist
			if ! [ -d "$SHA_DIR$CONTROL_DIR" ]
			then
				# create one
				mkdir -p "$SHA_DIR$CONTROL_DIR"
			else				
				# if sha file exist
				if [ -f "$SHA_DIR$CONTROL_DIR${file_name}.sha1" ]
				then
					# print ...
					echo "${file_name}.sha1 exists"
					#hashes[$file_name]=$sha
				else
					# create one
					echo "$sha" > "$SHA_DIR$CONTROL_DIR${file_name}.sha1"
					#hashes[$file_name]=$sha
				fi
				# if data file doesn't exists
				if ! [ -f "$DATA_DIR$CONTROL_DIR${file_name}.data" ]
				then
					# create one
					echo "$file_data" > "$DATA_DIR$CONTROL_DIR${file_name}.data"
				fi # fi data file doesn't exists
			fi # fi sha file's directory doesn't exists
		fi # fi create_flag = "c"
		hashes[${file_name}]=$sha
	done
}


