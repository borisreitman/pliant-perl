version=$1
pushd ../../..
name=pliant_perl-$version
rm /tmp/$name.tgz /tmp/$name.zip

for x in \
  'CVS' \
  "pliantx/test/CVS"  \
  "vc80.pdb"  \
  '\\.\\#'  \
  '*swp' \
  '.build' \
  'binary' \
  'pliperl' \
  '.configured' \
  'language/perl/config.pli' \
  '.dll' \
  ; do 
  echo $x >> "/tmp/pliant_perl_exclude_list_linux"; 
  echo $x >> "/tmp/pliant_perl_exclude_list_win32"; 
done

for x in \
  '.dll' \
  ; do echo $x >> "/tmp/pliant_perl_exclude_list_linux"; done
for x in \
  '.so' \
  ; do echo $x >> "/tmp/pliant_perl_exclude_list_win32"; done

tar czf /tmp/$name.tgz --exclude-from="/tmp/pliant_perl_exclude_list_linux" pliantx 
tar czf /tmp/$name-win32.tgz --exclude-from="/tmp/pliant_perl_exclude_list_win32" pliantx 

# convert to zip
mkdir /tmp/pliant_perl_tmp
tar xzvf /tmp/$name-win32.tgz -C /tmp/pliant_perl_tmp
pushd /tmp/pliant_perl_tmp
zip -r /tmp/$name.zip pliantx
popd
popd
rm -rf /tmp/pliant_perl_tmp
rm /tmp/pliant_perl_exclude_list_linux
rm /tmp/pliant_perl_exclude_list_win32
rm /tmp/$name-win32.tgz
