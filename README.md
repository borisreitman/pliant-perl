Pliant Perl Binding
-------------------

This was moved from SourceForge to GitHub. 

Pliant Perl binding brings Perl into [Pliant](http://fullpliant.org) and allows Pliant to access [CPAN](http://search.cpan.org), a large library of modules written in Perl. This is accomplished by embedding a perl interpreter inside the pliant process.

With this binding you can:

* Use DBI module from Pliant to issue SQL queries.
* Use wxPerl module to create GUI applications with Pliant.
* Use many other CPAN modules.

and,

* Call perl functions with variable number of arguments
* Invoke methods of Perl objects
* Subclass perl classes with implementation written in Pliant
* Manipulate perl's scalars, arrays and hashes, and references
* Pass callbacks written in Pliant to APIs originally designed to work with callbacks written in Perl.

### Installation

First install Pliant on your system and make sure it wordks. Then, follow instructions in `install/` subdirectory.


### Example: Access PostgreSQL through Perl's DBI

Here is a working sample program to access a PostgreSQL database through perl's DBI layer. More examples exist in 'pliantx/language/perl/examples' directory.

```
module "/pliantx/lexer/multiline_string.pli"
module "/pliantx/language/perl.pli" # THE KEY MODULE TO USE
module "/pliant/language/compiler.pli"

perl_eval {{ use DBI; }}
gvar PerlScalar dbh ref_records

dbh := perl_static DBI connect "dbi:Pg:dbname=test_db" "" ""
ref_records := dbh selectall_arrayref "select * from products;"

gvar PerlArray records := ref_records array   #deref 
gvar PerlArray record

for (gvar Int i) 0 records:size-1
  console "Record " i eol
  record := records:i:array
  for (gvar Int j) 0 record:size-1
    console j ": "  record:j eol

dbh disconnect 
```

Here's the output:

```
Record 0
0: A1
1: Apple
Record 1
0: A2
1: Orange
Record 2
0: A3
1: Banana
Record 3
0: A4
1: Peach
```

### Callback example

Here is another example that illustrates passing pliant callbacks to perl.

```
module "/pliantx/lexer/multiline_string.pli"
module "/pliant/language/compiler.pli"
module "/pliantx/language/perl.pli"

perl_eval {{
  sub run_callback {
    my $sub = $_[0];
    print "in run_callback $sub\n";
    my @a = &$sub("a","b","c");
    print "retval = @a\n";
  }
}}

function hello array -> retval
  arg_rw PerlArray array
  arg PerlArray retval

  console "Inside hello" eol
  each (var PerlScalar parameter) array
    console "Got arg = " parameter eol

  # set return value
  retval:0 := 1
  retval:1 := "a"

perl run_callback perl_callback:hello

perl_define "hello" hello
perl_eval "hello(1 .. 5);"
```

Here's the output,

```
in run_callback CODE(0x8083c80)
Inside hello
Got arg = a
Got arg = b
Got arg = c
retval = 1 a
Inside hello
Got arg = 1
Got arg = 2
Got arg = 3
Got arg = 4
Got arg = 5
```

#### Important note about {{ }} syntax

Special care must be taken when using {{ and }} syntax at the top of the file.

When the {{ and }} syntax comes in the beginning of a file, make sure that there is a line with some [Pliant](http://fullpliant.org) instruction above it. In above example we have two lines for the "module" keywords for compiler.pli and perl.pli packages. The module line for the multiline\_string.pli module does not count, because this module defines the {{ and }} syntax.

If in the example above, the module lines were reordered such that the multiline module came last, the program would not compile. Therefore, as a general practice, use the multiline\_string.pli module before the perl.pli module.

If your file only has one module directive at the top, which presumably includes perl and multiline modules as submodules, you need to put a dummy line before a use of {{ }} when it is at the top of the file. You can put "true" by itself on a line, for example:

```
# start of file
module "my_util_module.pli"
true
perl_eval {{
  print "works\n";
}}
#...
```

### Class Implementation example

This illustrates how it is possible to subclass existing Perl classes and override certain behavior. Here we subclass the parent class Parent with class T and implement its new method in Pliant. The method 'Parent::dump' is inherited.

```
module "/pliantx/lexer/multiline_string.pli"
module "/pliant/language/compiler.pli"
module "/pliantx/language/perl.pli"

perl_eval {{
  package Parent;
  sub new {
    return bless {},
    shift();
  }
  sub dump {
    my $self = shift;
    print $self->{message}, "\n";
  }

  package T;
  our @ISA = qw(Parent);
}}

perl_function new_T classname -> self
  arg Str classname ; arg PerlScalar self

  self := perl_ref (var PerlHash hash)
  self bless classname

  self:hash:"message" := "hello"
  self:hash:"_data"   := 10000 # or memory address of some Pliant data

perl_define "T::new" new_T

gvar PerlScalar t := perl_new T
t dump
```

### Draw gui with wxWindows library (via wxPerl)

The [wxWindows](http://www.wxwindows.org) library is a cross platform GUI library that looks correctly under different interfaces (windows, gtk+, mac-os). The trouble is that it is in C++ and to use it in pliant we need to write C wrappers. Turns out that there is already lots of similar work done to bring wxWindows into Perl. So why do chore work twice ? We can access wxWindows api via perl.

```
# this shows how to use the WxWindows C++ library through its Perl binding

module "/pliantx/lexer/multiline_string.pli"
module "/pliant/language/compiler.pli"
module "/pliantx/language/perl.pli"

perl_eval {{
  use strict;
  use Wx;
  use Data::Dumper;

  # every Wx program must have a Wx::App-derived class
  package MyApp;
  use vars qw(@ISA);
  @ISA = qw(Wx::App); }}

perl_function MyApp_OnInit self -> retval
  arg PerlScalar self retval
  var PerlScalar frame := perl_new MyFrame 
  self SetTopWindow frame
  frame Show 1
  retval := 1

perl_define "MyApp::OnInit" MyApp_OnInit

perl_eval {{
  package MyFrame;
  use Wx::Event;
  @MyFrame::ISA = qw(Wx::Frame); }}

gvar PerlScalar wxDefaultPosition := perl "Wx::wxDefaultPosition"
gvar PerlScalar wxITALIC_FONT     := perl "Wx::wxITALIC_FONT"

# helper function
function wx_vec x y -> point
  arg Float x y
  arg PerlScalar point
  var PerlArray pair
  pair 0 := x
  pair 1 := y
  point := perl_ref pair

perl_function MyFrame_OnPaint self event -> retval
  arg PerlScalar self event retval

  var PerlScalar dc := perl_new "Wx::PaintDC" self
  dc SetFont wxITALIC_FONT
  dc DrawText "Hello, world!" 10 10

perl_define "MyFrame::OnPaint" MyFrame_OnPaint

perl_function new_MyFrame classname -> self
  arg PerlScalar classname self
  self := perl_super MyFrame new perl_undef -1 "Hello, world!" wxDefaultPosition (wx_vec 350 100)
  perl 'Wx::Event::EVT_PAINT' self perl_callback:MyFrame_OnPaint

perl_define "MyFrame::new" new_MyFrame

# MAIN:
gvar PerlScalar app := perl_new MyApp
app MainLoop
```

### Syntax file for Vim

Grab [pliant.vim](pliant.vim) and place it in $HOME/.vim/syntax directory. Edit it to match the location of the perl syntax file.

The implementation of the pliant-perl project is in the Literate Programming style, using the noweb tool. Here is a noweb syntax file [nw.vim](files/nw.vim). Drop it into $HOME/.vim/syntax/ directory and edit it to match the location of perl and pliant syntax files on your system.

Configure vim to associate syntax files with extensions .pli and, if you want, .nw. To do this, copy filetype.vim from the vim's install direcotry, and put it into $HOME/.vim. Edit it and add,

```
" Pliant
au BufNewFile,BufRead *.pli     setf pliant

" NOWEB
au BufNewFile,BufRead *.nw      setf nw
```

There is probably a better way to do this, but that worked for me.

### The API in a nutshell

#### `PerlScalar, PerlArray, PerlHash`

These types wrap perl's array, hash, and scalar. Iterate through the PerlHash keys with 'each' keyword (see hash.pli example)

#### `perl`

Used to call functions or methods on an object,

```
perl func_name arg1 arg2 ...
perl obj method_name arg1 arg2 ...
```

Here "obj" is a blessed PerlScalar. You don't have to use the "perl" keyword when invoking a method on a constructed object. It will automatically figure out that this is a perl call, because obj is of type PerlScalar:

```
obj method_name arg1 arg2 ...
```

#### `perl_static, perl_super, perl_new`

Used to call static class methods. "perl\_static" allows the most general form, "perl\_super" calls a static method in the parent (SUPER) class. "perl\_new" is a shortcut to call the "new" constructor. Examples:

```
dbh := perl_static DBI connect data_source data_username data_password

# the following two are equivalent
obj := perl_new T arg1 arg2 ...
obj := perl_static T new arg1 arg2 ...

# the following two are equivalent
obj := perl_super  T new arg1 arg2 ...
obj := perl_static T "T::SUPER::new" arg1 arg2 ...
```

The lasts example is usefull to call the parent constructor in the implementation of T::new (see wxperl.pli example, MyFrame::new implementation).

#### `perl_function`

Used to tell that this function may be called from perl. This keyword will not be needed in the future, as everything will be autodetected.

```
perl_function non_perl_aware i j k -> r
	arg Str i j ; arg Int k ; arg Str r
	console i j k eol
	r := 10

perl_function somewhat_perl_aware obj i j -> r
	arg PerlScalar obj ; arg Int i j r
	obj dump  #call method on perl object
	console i j eol
	r := 20

function very_perl_aware args -> retval
	arg PerlArray args retval
	arg PerlScalar obj := args 0
	arg Int i j 
	i := args 1 ; j := args 2 
	obj dump
	console i j eol
	retval 0 := 20
	# retval 1 := 30  # return multiple values

perl iterate_over_datastructure   perl_callback:non_perl_aware
perl iterate_another_datastructure perl_callback:somewhat_perl_aware
perl iterate_another_datastructure perl_callback:very_perl_aware
```

Here is what the 'perl_function' keyword does in the background. It will create a function with the same name but with the signature `(PerlArray -> PerlArray)` which will delegate the call to the actual function.

#### `perl_define`

Used to bind a perl function name to pliant implementation.

```
perl_define "hello" hello
perl_define "T::new" new_T
```

The Pliant function must either be declared with 'perl\_function' or must receive a PerlArray and return a PerlArray.

#### `perl_callback`

Similar to `perl_define`, but is used to convert a pliant function address to a perl callback.

```
gvar PerlScalar callback :=  perl_callback hello 
perl run_callback callback
```

#### `perl_ref`

Make a perl reference to PerlScalar, PerlArray or PerlHash object. To dereference it, use the 'hash', 'array' or 'scalar' method.

```
var PerlHash hash
var PerlScalar r_hash := perl_ref hash

r_hash:hash "month" := "May"
```

#### `perl_eval`

Eval a string of perl code. Usefull to declare perl functions and "use" some perl modules. You may use '{{' and '}}' as string delimiters if you import the `multiline_string` module. Note that the escape of third to last brace is used to avoid closing the string too early "\\}}}". An alternative is to put a space before the last "}}".

```
perl_eval {{ 
  use Data::Dumper;
  sub run_callback { 
    my $sub = shift; 
    print "in run_callback $sub\n"; 
    my @a = &$sub("a","b","c"); 
    print "retval = @a\n";   
  \}}}
```

### See Also

- [Pliant homepage](https://www.fullpliant.org/)
