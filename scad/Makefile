
PREFIX=intval2

OPENSCAD=openscad
OPENSCAD_OPTIONS_STL=--enable manifold -D VERBOSE=false
OPENSCAD_OPTIONS_DXF=-D VERBOSE=false
ORDER_STL=python3 ./c14n_stl.py
	
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
	$(OPENSCAD) $(OPENSCAD_OPTIONS_STL) -o $@ -D PART=\"$(subst $(PREFIX)_,,$(subst .stl,,$(@F)))\" $<
	$(ORDER_STL) $@

$(LASER) : $(DXF)/$(PREFIX)_%.dxf : $(PREFIX).scad
	$(OPENSCAD) $(OPENSCAD_OPTIONS_DXF) -o $@ -D PART=\"$(subst $(PREFIX)_,,$(subst .dxf,,$(@F)))\" $<