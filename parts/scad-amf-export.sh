#!/bin/bash

EXPORT_PATH="AMF"
EXPORT_EXT="amf"

PARTS="scad-part-names.conf"
INCLUDE_PATH="$(pwd)/scad"

USAGE="Use \"-a\" to render and export all parts or \"-p <part-name>\" for a specific part."


render_and_export() {
	local start=$SECONDS
	echo "Rendering part $1..."
	if openscad -q -o $EXPORT_PATH/$1.$EXPORT_EXT <(echo "$INCLUDES $1();"); then
		local d=$(($SECONDS - $start))
		echo "Finished in $(($d/3600)) hours, $((($d/60) % 60)) minutes, $(($d % 60)) seconds."
		echo "Part exported to $EXPORT_PATH/$1.$EXPORT_EXT."
	else
		echo "Error: Failed to render part $1."
	fi
}


if [[ $@ < 1 ]]; then 
	echo "Error: No arguments specified."
	echo "$USAGE"
	exit 1
fi

INCLUDES=""
for f in "$INCLUDE_PATH"/*.scad; do
	INCLUDES+="use<$f>"
done

SECONDS=0
if [[ $1 == "-a" ]]; then
	while read -r line; do
		if [[ -n $line ]] && [[ ! ${line:0:1} == "#" ]]; then
			render_and_export $line
		fi
	done < $PARTS
elif [[ $1 == "-p" ]]; then
	render_and_export $2
elif [[ $1 == "-h" ]]; then
	echo "$USAGE"
	exit 0
else
	echo "Error: Invalid argument."
	echo $USAGE
	exit 1
fi
d=$SECONDS

echo "Total rendering and export time: $(($d / 3600)) hours, $((($d / 60) % 60)) minutes, $(($d % 60)) seconds."
