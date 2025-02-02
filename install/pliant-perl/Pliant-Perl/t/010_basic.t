use strict;
use warnings FATAL => 'all';

use Test::More tests => 2;
BEGIN { use_ok('Inline::Pliant'); };
ok(1);

__END__

Inline::Pliant::pliant_compile(q{
perl_function func1 x -> y
  arg Str x y
  y := x+x
perl_define "func1" func1
}
);

is(func1("A"), "AA");

