OUTPUT_DIR=fonts/variable
SOURCE_DIR=source

rm $OUTPUT_DIR -rf

for srcg in $SOURCE_DIR/*.glyphs
do
  fontmake -g $srcg -o ufo -i --subset --output-dir master_ufo
done

for srcd in $SOURCE_DIR/*.designspace
do
  fontmake -m $srcd -o variable --output-dir fonts/variable
done

for font in fonts/variable/*.ttf
do
  mv $font Russolo\[opsz,wght\].ttf
  gftools fix-nonhinting $font $font
  gftools fix-dsig $font --autofix
  # ttx to remove MVAR
    for ttf in *.ttf
    do ttx -f -x MVAR $ttf
      for ttx in *.ttx
        do ttx -f $ttx && rm $ttx
      done
    done
done

# Cleanup gftools mess:
rm $OUTPUT_DIR/*-backup-fonttools-prep-gasp.ttf

cp METADATA.pb $OUTPUT_DIR
cp DESCRIPTION.*.html $OUTPUT_DIR

export OPTIONS="--no-progress"
export OPTIONS="$OPTIONS --exclude-checkid /check/ftxvalidator" # We lack this on Travis.
# export OPTIONS="$OPTIONS --exclude-checkid /check/metadata" # Comment this out after creating a METADATA.pb file.
# export OPTIONS="$OPTIONS --exclude-checkid /check/description" # Comment this out after creating a DESCRIPTION.en_us.html file.
# export OPTIONS="$OPTIONS --exclude-checkid /check/varfont" Comment this out when making a variable font.
export OPTIONS="$OPTIONS --loglevel INFO --ghmarkdown Fontbakery-check-results.md"
fontbakery check-googlefonts $OPTIONS $OUTPUT_DIR/*.ttf
