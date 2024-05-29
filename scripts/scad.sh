SCRIPT_NAME="intval2"
SCAD="scad/${SCRIPT_NAME}.scad"

listParts () {
	cat "${1}" | grep 'PART ==' | grep -v 'debug' | awk -F'"' '{print $2}'
}

listLaser () {
	cat "${1}" | grep 'LASER ==' | grep -v 'debug' | awk -F'"' '{print $2}'
}

renderPart () {
	part="${1}"
	echo "renderPart ${part}"
	stl="stl/${SCRIPT_NAME}_${part}.stl"
	openscad --export-format asciistl -o "${stl}" -D "LASER=\"\";" -D "PART=\"${part}\";" "${SCAD}"
}

renderLaser() {
	laser="${1}"
	echo "renderLaser ${laser}"
	dxf="dxf/${SCRIPT_NAME}_${laser}.dxf"
	openscad -o "${dxf}" -D "PART=\"\";" -D "LASER=\"${laser}\";" "${SCAD}"
}

allParts () {
	PARTS=($(listParts "${SCAD}"))
	for part in "${PARTS[@]}"; do
		renderPart "${part}" 
	done

	LASERS=($(listLaser "${SCAD}"))
	for laser in "${LASERS[@]}"; do
		renderLaser "${laser}"
	done
}

allParts