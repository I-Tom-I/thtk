#!/bin/bash

if [ "$1" == "" ]; then
  echo "No version given."
  exit 1
fi

releasepath=thtk-bin-$1
echo Generating $releasepath
rm -rf $releasepath
mkdir $releasepath
rm -rf $releasepath-pdbs
mkdir $releasepath-pdbs

for i in thanm thecl thdat thmsg; do
  echo $i
  groff -mdoc -Tutf8 $i/$i.1 | perl -pe 's/\e\[?.*?[\@-~]//g' | unix2dos > $releasepath/README.$i.txt
  cp build/$i/RelWithDebInfo/$i.exe $releasepath/
  cp build/$i/RelWithDebInfo/$i.pdb $releasepath-pdbs/
done
cp build/thtk/RelWithDebInfo/thtk.dll $releasepath/
cp build/thtk/RelWithDebInfo/thtk.lib $releasepath/
cp build/thtk/RelWithDebInfo/thtk.pdb $releasepath-pdbs/
cp "$(cygpath "$VSSDK140Install")/../VC/redist/x86/Microsoft.VC140.OPENMP/vcomp140.dll" $releasepath/

copy_doc() {
  while [ "$1" != "" ]; do
    cat $1 | unix2dos > $releasepath/$1.txt
    shift
  done
}
copy_doc COPYING.{bison,flex,libpng,zlib} COPYING README NEWS

zip -r -9 $releasepath.zip $releasepath
zip -r -9 $releasepath-pdbs.zip $releasepath-pdbs
