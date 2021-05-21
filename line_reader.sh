
function LinesToArr() {		# $1 - returned arr
	local -n lines=$1
	
	line=""
	
	while IFS= read line
	do
		lines+=("${line}")
	done
	
	unset lines[0]
}
