SCRIPT_NAME="intval2"
SCAD="scad/${SCRIPT_NAME}.scad"

listParts () {
	cat "${1}" | grep 'PART ==' | grep -v 'debug' | awk -F'"' '{print $2}'
}

renderPart () {
	part="${1}"
	stl="stl/${SCRIPT_NAME}_${part}.stl"
	openscad --export-format asciistl -o "${stl}" "${SCAD}"
}

allParts () {
	PARTS=($(listParts "${SCAD}"))
	for part in "${PARTS[@]}"; do
		renderPart "${part}"
	done
}

allParts