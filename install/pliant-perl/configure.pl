use File::Basename;
use File::Path 'mkpath';
my $prefix="../../language/perl";
my $prefix_win='..\\..\\language\\perl';
my $win32_base = $^X =~ m|bin/perl| ? "c:/Perl/bin" : dirname($^X);
my ($pliant_exe, $exe_extension);
if ( lc($^O) eq 'mswin32' || lc($^O) eq 'cygwin' ) {
	$pliant_exe = "pliant-debug1.exe";
  $exe_extension = ".bat";
} else {
	$pliant_exe = "pliant";
  $exe_extension = "";
}

open CONFIG, ">$prefix/config.pli" or die "Can't write config file: $!";
print CONFIG q{
module "/pliant/admin/file.pli"

function file_exists path -> retval
  arg Str path
  arg CBool retval
  var FileInfo info := file_query path standard
  retval := info:size >= 0

function find_perl_library -> path
  arg Str path
  if file_exists:"file:/usr/lib/libperl.so.5.8"
    path := "/usr/lib/libperl.so.5.8"
  eif file_exists:"file:/usr/lib/libperl.so.5.6"
    path := "/usr/lib/libperl.so.5.6"
  else
    path := "/usr/lib/libperl.so"
  if not file_exists:("file:"+path)
    path := "} . $win32_base . '\perl58.dll' . q{" 

function find_wrapper_library -> path
  arg Str path
  path := file_os_name:"/pliantx/language/perl/liblperl.so"
  if not file_exists:("file:"+path)
    path := file_os_name:"/pliantx/language/perl/lperl.dll"

export find_perl_library find_wrapper_library
};
close CONFIG;

if ( lc($^O) eq 'mswin32' || lc($^O) eq 'cygwin' ) {
  open(PLIPERL, ">bin/pliperl.bat") or die "can't write file: $!\n";
  print PLIPERL q{pliant-debug1.exe 'precompile /pliantx/install/pliant-perl/binary/perl.dump module /pliantx/language/perl.pli module /pliantx/lexer/multiline_string.pli' %1 %2 %3 %3 %4 %5 %6 %7 %8 %9};
  close PLIPERL;
} else {
  open(PLIPERL, ">bin/pliperl") or die "can't write file: $!\n";
  print PLIPERL q{pliant 'precompile /pliantx/install/pliant-perl/binary/perl.dump module /pliantx/language/perl.pli module /pliantx/lexer/multiline_string.pli' $*};
  close PLIPERL;
}

mkpath "binary";
unlink "binary/perl-debug1.dump";
chmod (0755, "bin/pliperl$exe_extension");

