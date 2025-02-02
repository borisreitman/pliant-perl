Installation for Binary version (not from CVS)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	
  1. On Linux
  ~~~~~~~~
    Get the pliant_perl-VERSION-bin-linux-5.X.tgz archive that 
    matches the version of perl on your system (either 5.6
    or 5.8; to find out look at the output of perl -v).

    Untar the archive:

      $ tar xzvf pliant_perl-VERSION.tgz -C /pliant
      $ cd /pliant/pliantx/install/pliant-perl
      $ perl configure.pl
      $ perl run_tests.pl

      - optionally arrange 'bin/pliperl' to be in your path 
	(copy or symlink or modify PATH environment variable)

    If Tests Fail, Rebuild a Shared Library
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      First make sure that you have a symlink /usr/lib/libperl.so.  
      pointing to /usr/lib/libperl.so.5.X here X is either 6 or 8 depending
      on the version of perl on your system.

      (If you are using debian or ubuntu, this symlink is provided by 
      the libperl-dev package.)

      If any of the tests fail, you need to rebuild the liblperl.so library
      to match your system.  Also please report this problem by emailing me
      with the parameters of your system.  To rebuild the .so, issue these commands,
        
        $ cd /pliant/pliantx/language/perl
        $ perl Makefile.PL
        $ make clean_dll
        $ make dll
          
      And, rerun the tests:

        $ cd /pliant/pliantx/install/pliant-perl
        $ perl run_tests.pl

  2. On Windows
  ~~~~~~~~~~~~~
  Only tested on Windows 2000 Professional.

    2.1 ActivePerl
    ~~~~~~~~~~~~~~
    Make sure that you have ActiveState Perl 5.8 installed
    which can be downloaded from http://www.activestate.com

    2.2: Need msvcr80.dll
    ~~~~~~~~~~~~~~~~~~~~~
    Make sure that there is msvcr80.dll on your system.  If not,
    download it from http://pliant-perl.sf.net/files/msvcr80.dll
    and place it in c:\winnt\system32  or anywhere else in the path.

    2.3: pliant-debug1.exe in path
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Add c:\pliant\binary to your path in order for pliant-debug1.exe to be
    found in the path.

    2.4 Uncompress pliant_perl-VERSION.zip into c:\pliant
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    You may use your favorite zip program.  Below the free 7-zip program
    (http://www.7-zip.org) is used:
      
      c:\> cd c:\pliant
      c:\pliant> c:\7zip\7z x -y path/to/pliant_perl-VERSION.zip 

    2.5 Configure pliant-perl installation and run tests
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

      c:\> cd c:\pliant\pliantx\install\pliant-perl
      c:\pliant\pliantx\install\pliant-perl> perl configure.pl
      c:\pliant\pliantx\install\pliant-perl> perl run_tests.pl

      - optionally arrange 'bin\pliperl.bat' to be in your path 
        (e.g. copy to c:\winnt or modify PATH environment variable)

    If Tests Fail, Rebuild a DLL
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

      If any of the tests fail, you need to rebuild the lperl.dll dynamic library
      to match your system.  Also please report this problem by emailing me
      with the parameters of your system.  To rebuild the .dll, first make sure
      that you have the Visual C++ compiler tools.  Luckily, a *free* version
      of the VC tools can be used:

        - VC Compiler 
          http://msdn.microsoft.com/vstudio/express/visualc/default.aspx
          (you don't need to install the IDE).
        - Platform SDK:
          http://www.microsoft.com/downloads/details.aspx?familyid=A55B6B43-E24F-4EA3-A93E-40C0EC4F68E5&displaylang=en

      Place the vcvars32.bat provided with the VC++ compiler somewhere in your path
      (for example c:\winnt).  Then issue these commands,
        
        c:\> cd c:\pliant\pliantx\language\perl
        c:\pliant\pliantx\language\perl> perl Makefile.PL
        c:\pliant\pliantx\language\perl> vcvars32.bat
        c:\pliant\pliantx\language\perl> nmake clean_dll
        c:\pliant\pliantx\language\perl> nmake dll

      And, rerun the tests,

        c:\> cd c:\pliant\pliantx\install\pliant-perl
        c:\pliant\pliantx\install\pliant-perl> perl run_tests.pl

Installation from CVS 
~~~~~~~~~~~~~~~~~~~~~
  
  3. On Linux
  ~~~~~~~~~~~
    You will need install the NOWEB tools and Latex.  
    (On debian and ubuntu NOWEB is provided by 'nowebm' package.)

    Also make sure to have a symlink /usr/lib/libperl.so pointing
    to libperl.so.5.8.  (On debian and ubuntu it is created by the
    libperl-dev package.)

    To fetch the sources from CVS,
      $ cd /pliant
      $ cvs -d:pserver:anonymous@pliant-perl.cvs.sourceforge.net:/cvsroot/pliant-perl login
      $ cvs -z3 -d:pserver:anonymous@pliant-perl.cvs.sourceforge.net:/cvsroot/pliant-perl co -d pliantx pliant-perl/pliantx

    Then, 
      $ cd /pliant/pliantx/install/pliant-perl
      $ perl Makefile.PL
      $ make 
      $ make test

      - optionally arrange 'bin/pliperl' to be in your path 
	(copy or symlink or modify PATH environment variable)

  4. On Windows
  ~~~~~~~~~~~~~
    Only tested on Windows 2000 Professional.

    4.1 Install all the needed prerequisites
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      - ActiveState perl 
          http://www.activestate.com
      - Cygwin (install it before NOWEB)  
          http://www.cygwin.com
      - NOWEB tools 
          http://www.literateprogramming.com/noweb/nowebinstall.html
      - VC Compiler 
          http://msdn.microsoft.com/vstudio/express/visualc/default.aspx
          (you don't need to install the IDE).
      - VC Platform SDK:
          http://www.microsoft.com/downloads/details.aspx?familyid=A55B6B43-E24F-4EA3-A93E-40C0EC4F68E5&displaylang=en
      - CVS Client (cygwin has one)

    After VC compiler is installed, copy vcvars32.bat that came 
    with it somewhere in your path (e.g. c:\winnt).

    4.2: Place pliant-debug1.exe in path
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Add c:\pliant\binary to your path in order for pliant-debug1.exe to be
    found in the path.

    4.3  Fetch pliant-perl from CVS
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    To fetch the sources from anonymous CVS, using cygwin's cvs 

      $ cd /cygdrive/c/pliant
      $ cvs -d:pserver:anonymous@cvs.sourceforge.net:/cvsroot/pliant-perl login
      $ cvs -z3 -d:pserver:anonymous@cvs.sourceforge.net:/cvsroot/pliant-perl co -d pliantx pliant-perl/pliantx

    4.4 Configure it
    ~~~~~~~~~~~~~~~~
    First, in cmd.exe use VC tools to build the dll,

      c:> cd c:\pliant\pliantx\install\pliant-perl
      c:\pliant\pliantx\install\pliant-perl> perl configure.pl

      c:> cd ..\..\language\perl
      c:\pliant\pliantx\language\perl> perl Makefile.PL
      c:\pliant\pliantx\language\perl> vcvars32.bat
      c:\pliant\pliantx\language\perl> nmake dll

    Then, go into Cygwin's bash and do the rest there:

      $ cd /cygdrive/c/pliant/pliantx/install/pliant-perl
      $ perl Makefile.PL
      $ make all_but_dll
      $ make test

      - optionally arrange 'bin\pliperl.bat' to be in your path 
        (e.g. copy to c:\winnt or modify PATH environment variable)

Notes for Developers
--------------------
This project is written in Literate Programming style.  All the code is
embedded into the documentation. The full installation procedure will
extract the code from the documentation, and also generate documentation
in PDF.  To regenerate the code and documentation use "make pdf" command. 
For this you will need NOWEB and LaTeX installed.

- Every X.nw file generates one or more .pli files
  (file X.pli in the same directory)
- Every X.nw file generates an install/tmp/X.tex file. The files are 
  sourced in by master file pliant-perl.nw.  The documentation 
  is put into doc/ in DVI, PostScript and PDF formats.
- The build framework is controlled by Makefile.PL
- Changes should be done to .nw files, not .pli files.  After change is done,
  run 'make all' on linux or 'make all_but_dll' on windows.

Author
------
Boris Reitman 
B O R I S   @   R E I T M A N   .   N A M E
