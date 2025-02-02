my $in;
sub escape {
  my $x = shift;
  my $y = substr($x, length($x)-1, 1);
  my $x = substr($x, 0, length($x)-1);
  my $l = int(length($x)/2);
  my $prefix = "\\" x $l;
  return $prefix . $y;
}

while(<>) { 
  if (!$in && /<pre>/) {
    $in = 1;
  } elsif ($in && /<\/pre>/) {
    $in = 0;
  } elsif (!$in) {
    s|^\s*$|<p>|;
    s|\\documentclass{(.*)}||;
    s|\\begin{document}||;
    s|\\maketitle||;
    s|\\end{document}||;
    s|\\emph{(.*)}|<EM>\1</EM>|;
    s|\\section{(.*)}|<H1>\1</H1>|;
    s|\\subsection{(.*)}|<H2>\1</H2>|;
    s|\\title{(.*)}|<H1>\1</H1>|;
    s|\\author{(.*)}|Author: \1|;
    s|\\subsubsection{(.*)}|<H3>\1</H3>|;
    s|\\begin{verbatim}|<BLOCKQUOTE> <PRE>|m;
    s|\\end{verbatim}|</PRE> </BLOCKQUOTE> |m;
    s|\\footnote{(.*)}| (<small>note: \1</small>)|;
    s|(\\+.)|&escape($1)|eg;
    s|\$(.*?)\$|<i>\1</i>|g;
  }
  s|<pre>|<blockquote><pre>|;
  s|</pre>|</pre></blockquote>|;
  print;
}
