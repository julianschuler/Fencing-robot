#!/bin/bash

EXPORT_PATH="AMF"
EXPORT_EXT="amf"
INPUT_FILE="scad/export.scad"
USAGE="Use \"-a\" to render and export all parts or \"-p <part-name>\" for a specific part."


render_and_export() {
	local start=$SECONDS
	echo "Rendering part $1..."
	openscad -q -o $EXPORT_PATH/$1.$EXPORT_EXT -D part=\"$1\" $INPUT_FILE
	local d=$SECONDS - start
	echo "Finished in $(($d/3600)) hours, $((($d/60) % 60)) minutes, $(($d % 60)) seconds." 
	echo "Part exported to $EXPORT_PATH/$1.$EXPORT_EXT."
	
}


if [[ $@ < 1 ]]; then 
	echo "Error: No arguments specified."
	echo $USAGE
	exit 1
fi


SECONDS=0
if [[ $1 == "-a" ]]; then
	while IFS= read -r line; do
		render_and_export $line
	done < scad-part-names.txt
elif [[ $1 == "-p" ]]; then
	render_and_export $2
elif [[ $1 == "-h" ]]; then
	echo $USAGE
	exit 0
else
	echo "Error: Invalid argument."
	echo $USAGE
	exit 1
fi
d=$SECONDS

echo "Total rendering and export time: $(($d / 3600)) hours, $((($d / 60) % 60)) minutes, $(($d % 60)) seconds."
