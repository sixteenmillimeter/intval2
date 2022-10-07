
PREFIX=intval2

OPENSCAD=openscad
OPENSCAD_OPTIONS=-D VERBOSE=false

STL=../stl
DXF=../dxf
MODELS=$(shell cat models.txt | tr '\n' ' ')
LASER=$(shell cat laser.txt | tr '\n' ' ')

all:	directories models

directories:
	mkdir -p $(STL) $(DXF)

models: directories $(MODELS) $(LASER)

clean:
	rm -f $(STL)/$(PREFIX)_*

cleanall:
	rm -rf $(STL)

# Dependencies for models

$(MODELS) : $(STL)/$(PREFIX)_%.stl : $(PREFIX).scad
	$(OPENSCAD) $(OPENSCAD_OPTIONS) -o $@ -D PART=\"$(subst $(PREFIX)_,,$(subst .stl,,$(@F)))\" $<

$(LASER) : $(DXF)/$(PREFIX)_%.dxf : $(PREFIX).scad
	$(OPENSCAD) $(OPENSCAD_OPTIONS) -o $@ -D PART=\"$(subst $(PREFIX)_,,$(subst .dxf,,$(@F)))\" $<