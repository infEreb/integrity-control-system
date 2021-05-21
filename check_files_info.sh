#!/usr/bin/env bash

source ./global_funcs.sh
include ./line_reader.sh

LsInfoToArr FILES_DATA
Hashing FILES_DATA HASH_ARR "n"

log=""

for file_name in "${!HASH_ARR[@]}"
do
	sha_file="$SHA_DIR$CONTROL_DIR${file_name}.sha1"
	if [ -f "$sha_file" ]
	then
		read saved_sha < "$sha_file"
		#echo "${saved_sha} - ${HASH_ARR[$file_name]}"
		if ! [ $saved_sha = ${HASH_ARR[$file_name]} ]
		then
			mess="File's data has been changed (${CONTROL_DIR}${file_name}) from $(ls $CONTROL_DIR -l | grep "$file_name$" | awk '{print $6" "$7" "$8}')"
			log+="${mess}\n"
			#echo "$mess" | boxes
			printf "$log" > integrity.log
		fi
	else
		log+="It's a new file (${file_name}), if u wanna update hashes of directory (${CONTROL_DIR}) u need execute '~/create_files_info.sh'\n"
	fi
done

# if no changes
if [ "$log" = "" ] 
then
	log+="File's data has no changes\n"
fi

printf "$log" | boxes
