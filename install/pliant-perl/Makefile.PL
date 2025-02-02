use strict;
my ($make, $del, $deltree, $mkpath, $cmdprefix, $run_tests_cmd, $test_deps);
if (lc($^O) eq 'mswin32') { 
  $make='nmake';
  $del='del';
  $deltree='del';
  $mkpath='mkdir -p';
  $cmdprefix = 'cmd /C';
} else {
  $make='make';
  $del='rm';
  $deltree='rm -rf';
  $mkpath='mkdir';
  $cmdprefix = '';
}

my $makefile_default;
if (lc($^O) eq 'mswin32' || lc($^O) eq 'cygwin') {
  $test_deps = 'children';
  $makefile_default .= <<EOT;
default:
	echo "Wrong usage. Please read /pliant/pliantx/install/pliant-perl/README"	

all_but_dll: children \$(HTML)

EOT
} else {
  $test_deps = 'all';
  $makefile_default .= <<EOT;
all: .configured children \$(HTML)
	cd ../../language/perl; make dll
EOT
}

open MAKEFILE, ">Makefile";
  print MAKEFILE qq{
MAKE=$make
DEL=$del
DELTREE=$deltree
MKPATH=$mkpath
CMDPREFIX=$cmdprefix
RUN_TESTS_CMD=$run_tests_cmd
TEST_DEPS=$test_deps
} . q{
BASE=pliant-perl
NOWEB=pliant-perl.nw
MAKEFILE=Makefile.nw
DOCDIR=doc
CODEDIR=../..
TMPDIR=tmp
PERLCODE=$(CODEDIR)/language/perl
LEXERCODE=../../lexer

SRC = pliant-perl.nw 
DEFS = $(SRC:%.nw=.build/%.defs)
TEX = $(SRC:%.nw=.build/%.tex)
HTML = $(SRC:.nw=.html)
PLI = $(SRC:.nw=.pli)
TOOLSDIR=../../install/pliant-perl
alldefs = .build/all_defs
}.
$makefile_default .
q{
test : $(TEST_DEPS)
	perl run_tests.pl

.configured :
	perl configure.pl
	echo 1 > .configured

children: 
	cd ../../language/perl; perl Makefile.PL; make all_but_dll
	cd ../../lexer/; make

preview: $(DOCDIR)/$(BASE).dvi;

clean: 
	-rm -rf .build .configured $(HTML)
	-cd ../../language/perl; rm config.pli
	-cd ../../language/perl; make purge
	-cd ../../lexer; make clean

purge: clean
	rm Makefile

.build: 
	$(MKPATH) .build

.build/%.defs : %.nw .build
	nodefs $< > $@

$(alldefs) : $(DEFS) 
	sort -u $(DEFS) | cpif $@

.build/%.tex : %.nw .build $(alldefs)
	noweave -n -indexfrom $(alldefs) $< > $@

%.html: %.nw $(alldefs)
	noweave -n -indexfrom $(alldefs) -index -html $(alldefs) $< | perl $(TOOLSDIR)/bin/noweb_postprocess_html.pl > $@

$(TMPDIR)/$(BASE).tex: $(NOWEB) $(TEXFILES)
	mkdir -p $(TMPDIR);
	noweave -delay -latex -index $(NOWEB) > $(TMPDIR)/$(BASE).tex
	
$(DOCDIR)/$(BASE).dvi: $(TEXFILES) $(NOWEB) $(TMPDIR)/$(BASE).tex
	mkdir -p $(DOCDIR)
	cd $(TMPDIR); latex $(BASE); noindex $(BASE); latex $(BASE)
	mv $(TMPDIR)/$(BASE).dvi $(DOCDIR)
	
$(DOCDIR)/$(BASE).ps: $(DOCDIR)/$(BASE).dvi
	cd $(DOCDIR); dvips -E -o $(BASE).ps $(BASE).dvi 
	
$(DOCDIR)/$(BASE).pdf: $(DOCDIR)/$(BASE).ps
	cd $(DOCDIR); ps2pdf $(BASE).ps $(BASE).pdf
};
close MAKEFILE;

