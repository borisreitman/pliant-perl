open MAKEFILE, ">Makefile";
print MAKEFILE q{
default:
	echo "Wrong usage. Please read /pliant/pliantx/install/pliant-perl/README"	
};

if (lc($^O) eq 'mswin32' || lc($^O) eq 'cygwin') { 
  print MAKEFILE q{
CC=cl
OPTS=#/DDEBUG=1
CLEAN_DLL=lperl.dll t/000_test_dll* t/lib/test_mod.*

# ActivePerl + free VC compiler
PERL_CCOPTS=-nologo -GF -W3 -MD -Zi -DNDEBUG -DWIN32 -D_CONSOLE -DNO_STRICT -DHAVE_DES_FCRYPT -DNO_HASH_SEED -DUSE_SITECUSTOMIZE -DPERL_IMPLICIT_CONTEXT -DPERL_IMPLICIT_SYS -DUSE_PERLIO -DPERL_MSVCRT_READFIX  -I"C:/Perl/lib/CORE" 
PERL_LDOPTS=-nologo -nodefaultlib -debug -libpath:"C:/Perl/lib/CORE"  -machine:x86  C:/Perl/lib/CORE/perl58.lib C:/msvc/VC/LIB/oldnames.lib C:/msvc/VC/LIB/kernel32.lib C:/msvc/VC/LIB/msvcrt.lib

dll : lperl.dll t/lib/test_mod.dll t/000_test_dll.exe

t/lib:
	mkdir t\lib

t/000_test_dll.exe: t/src/000_test_dll.c 
	$(CC) /ot/000_test_dll.exe t/src/000_test_dll.c 
	del 000_test_dll.obj vc80.pdb

t/lib/test_mod.dll: t/src/test_mod.c t/src/test_mod.def t/lib
	$(CC) -Gz -Fot/lib/test_mod.o -Tpt/src/test_mod.c 
	lib -out:test_mod.lib t/lib/test_mod.o
	link -out:t/lib/test_mod.dll -DLL -def:t/src/test_mod.def -implib:t/lib/test_mod.lib t/lib/test_mod.o
	del test_mod.obj test_mod.lib test_mod.exe vc80.pdb

#t/lib/test_mod.dll: t/src/test_mod.c t/src/test_mod.def
#        gcc -c t/src/test_mod.c -o t/lib/test_mod.o
#        dllwrap t/lib/test_mod.o --def t/src/test_mod.def -o t/lib/test_mod.dll -lws2_32

lperl.dll: lperl.c lperl.def
	$(CC) -Folperl.o -Tplperl.c $(PERL_CCOPTS) $(PERL_LDOPTS) $(OPTS)
	lib -out:lperl.lib lperl.o
	link -out:lperl.dll -DLL -def:lperl.def -implib:lperl.lib lperl.o $(PERL_LDOPTS)
	del lperl.ilk lperl.obj lperl.o lperl.lib lperl.pdb lperl.exe.manifest lperl.dll.manifest lperl.exe lperl.exp vc80.pdb

clean_dll:
	del t\000_test_dll* t\lib\* lperl.dll
};
} else {
  print MAKEFILE q{
CLEAN_DLL=liblperl.so
dll: liblperl.so
liblperl.so: lperl.c 
	$(CC) -ggdb -shared -o liblperl.so lperl.c `/usr/bin/perl -MExtUtils::Embed -e ccopts -e ldopts` 

clean_dll: 
	rm liblperl.so
};
}

print MAKEFILE q{
CC=gcc
SRC = callback.nw call.nw
DEFS = $(SRC:%.nw=.build/%.defs)
TEX = $(SRC:%.nw=.build/%.tex)
HTML = $(SRC:.nw=.html)
PLI = $(SRC:.nw=.pli)
TOOLSDIR=../../install/pliant-perl
alldefs = .build/all_defs

all_but_dll: .build/all_defs children $(TEX) $(HTML) $(PLI) 

children: 
	cd types && make all; 

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

purge: 
	rm $(CLEAN_DLL) $(HTML) $(TEX) $(DEFS) $(alldefs) vc80.pdb Makefile
	rm -r .build
};
close MAKEFILE;
