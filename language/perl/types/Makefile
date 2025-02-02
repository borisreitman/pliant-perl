CC=gcc
SRC = array.nw hash.nw
DEFS = $(SRC:%.nw=.build/%.defs)
TEX = $(SRC:%.nw=.build/%.tex)
HTML = $(SRC:.nw=.html)
PLI = $(SRC:.nw=.pli)
TOOLSDIR=../../../install/pliant-perl
alldefs = .build/all_defs

all : .build/all_defs $(TEX) $(HTML) $(PLI)

.build: 
	mkdir -p .build

.build/%.defs : %.nw .build
	nodefs $< > $@

$(alldefs) : $(DEFS) 
	sort -u $(DEFS) | cpif $@

.build/%.tex : %.nw .build $(alldefs)
	noweave -n -indexfrom $(alldefs) $< > $@

%.html: %.nw $(alldefs)
	noweave -n -indexfrom $(alldefs) -index -html $(alldefs) $< | perl $(TOOLSDIR)/bin/noweb_postprocess_html.pl > $@

%.pli: %.nw $(alldefs)
	notangle -R$@ $< > $@
