use strict;
package MyStrap;
use lib 'lib';
use base 'Test::Harness::Straps';
sub _command_line {
  my ($self, $file) = @_;
  if ($file =~ /exe$/) {
    return $file;
  } else {
    if (lc($^O) eq 'mswin32' || lc($^O) eq 'cygwin') {
       return 'cmd /C ..\\\\..\\\\install\\\\pliant-perl\\\\bin\\\\pliperl.bat module ' . $file;
    } else {
       my $cmd = ($] - 5.006 >= 0.002) ? '../../install/pliant-perl/bin/pliperl' : 'pliant';
       return "$cmd module $file";
    }
  }
}

eval { require POSIX; &POSIX::WEXITSTATUS(0) };
if( $@ ) {
    *_wait2exit = sub { $_[0] >> 8 };
}
else {
    *_wait2exit = sub { POSIX::WEXITSTATUS($_[0]) }
}

sub analyze_file {
    my($self, $file) = @_;

    # *sigh* this breaks under taint, but open -| is unportable.
    my $line = $self->_command_line($file);

    unless ( open(FILE, "$line|" )) {
        print "can't run $file. $!\n";
        return;
    }

    my %results = $self->analyze_fh($file, \*FILE);
    my $exit    = close FILE;
    $results{'wait'} = $?;
    if( $? && $self->{_is_vms} ) {
        eval q{use vmsish "status"; $results{'exit'} = $?};
    }
    else {
        $results{'exit'} = _wait2exit($?);
    }
    $results{passing} = 0 unless $? == 0;

    $self->_restore_PERL5LIB();

    return %results;
}

package main;
use Test::Harness;
$Test::Harness::Strap = MyStrap->new;

my @tests;
my @common_tests = qw(
  /pliantx/language/perl/t/002_call.pli
  /pliantx/language/perl/t/010_callback.pli
  /pliantx/language/perl/t/015_array.pli
  /pliantx/language/perl/t/020_hash.pli
  /pliantx/language/perl/t/030_autofunc.pli
  /pliantx/language/perl/t/040_cast.pli
  /pliantx/language/perl/t/050_class.pli
  /pliantx/language/perl/t/060_ref.pli

  /pliantx/lexer/t/001_multiline_basic.pli
  /pliantx/lexer/t/002_multiline_code.pli
); 

if (lc($^O) eq 'mswin32' or lc($^O) eq 'cygwin') { 
  @tests = (qw(
    t\\\\000_test_dll.exe
    /pliantx/language/perl/t/001_test_dll.pli
    ), @common_tests);
} else {
  @tests = @common_tests;
}

chdir('../../language/perl');
Test::Harness::runtests(@tests);
chdir('../../install/pliant-perl');
