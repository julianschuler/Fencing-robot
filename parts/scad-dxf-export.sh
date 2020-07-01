#!/bin/bash


# defaults
EXPORT_PATH="DXF"
EXPORT_EXT="dxf"

PART_NAME_FILE="scad-plate-names.conf"
INCLUDE_PATH="scad"


# print correct usage and exit
print_usage() {
	echo "Usage: $(basename $BASH_SOURCE) [OPTION]... [part-name]..."
	echo "Export parts specified by name from OpenSCAD files."
	echo ""
	echo "  -a          export all parts using the default settings"
	echo "  -f <file>   file to read part from"
	echo "  -i <file>   .scad file to include"
	echo "  -I <dir>    path to directory for .scad files to include"
	echo "  -o <dir>    path to directory for rendered files to be exported"
	echo "  -t <ext>    export file type (default: dxf)"
	echo "  -h          open this help chart"
	exit 0
}


# print error message and exit
print_error() {
	if [[ "$#" > 0 ]]; then
		echo "$1" 1>&2
	fi
	echo "Use \"$(basename $BASH_SOURCE) -h\" for further information." 1>&2
	exit 1
}


# render and export part with the name given by the first parameter
render_and_export() {
	local start=$SECONDS
	echo "Rendering part $1..."
	if openscad -q -o $export_path/$1.$export_ext <(echo "$includes projection() $1();"); then
		local d=$(($SECONDS - $start))
		echo "Finished in $(($d/3600)) hours, $((($d/60) % 60)) minutes, $(($d % 60)) seconds."
		echo "Part exported to $export_path/$1.$export_ext."
	else
		echo "Error: Failed to render part $1."
	fi
}



declare -a parts
file=""
includes=""
include_path="$(readlink -f $INCLUDE_PATH)"
export_path="$EXPORT_PATH"
export_ext="$EXPORT_EXT"


# check if arguments were specified
if [[ "$#" == 0 ]]; then
	print_error "No arguments specified."
fi

# parse flags
while getopts 'af:i:I:o:e:h' flag; do
	case "${flag}" in
		a) file="$PART_NAME_FILE" ;;
		f) file="${OPTARG}" ;;
		i) includes="use<${OPTARG}>" ;;
		I) include_path="$(readlink -f ${OPTARG})" ;;
		o) export_path="${OPTARG}" ;;
		t) export_ext="${OPTARG}" ;;
		h) print_usage ;;
		?) print_error ;;
	esac
done
shift $(( OPTIND - 1 ))

# include remaining argments as part names
for part in "$@"; do
	parts+=("$part")
done

# include files at the include path
for f in "$include_path"/*.scad; do
	includes+="use<$f>"
done

# read part names from file if specified
if [[ -n "$file" ]]; then
	if [[ ! -f "$file" ]]; then
		print_error "File \"$file\" not found."
	fi
	while read -r line; do
		if [[ -n "$line" ]] && [[ ! "${line:0:1}" == "#" ]]; then
			parts+=("$line")
		fi
	done < "$file"
fi

if [[ "${#parts[*]}" == 0 ]]; then
	print_error "No parts specified."
fi

# render specified parts
SECONDS=0
for part in "${parts[@]}"; do
	render_and_export "$part" "$includes"
done
d=$SECONDS

# print out total rendering and export time
echo "Total rendering and export time: $(($d / 3600)) hours, $((($d / 60) % 60)) minutes, $(($d % 60)) seconds."
