OUTPUT_DIR=fonts/variable
SOURCE_DIR=source

rm $OUTPUT_DIR -rf

for src in $SOURCE_DIR/*.designspace
do
  fontmake -m $src -o variable --output-dir $OUTPUT_DIR/
done

for font in $OUTPUT_DIR/*.ttf
do
  mv $font Russolo\[opsz,wght\].ttf
  gftools fix-nonhinting $font $font
  gftools fix-dsig $font --autofix
  # ttx to remove MVAR
    for ttx in $OUTPUT_DIR/*.ttx
    do
      ttx -x MVAR $font
      ttx $ttx
      rm $ttx
    done
  mv 

done

# Cleanup gftools mess:
rm $OUTPUT_DIR/*-backup-fonttools-prep-gasp.ttf

cp METADATA.pb $OUTPUT_DIR
cp DESCRIPTION.*.html $OUTPUT_DIR

export OPTIONS="--no-progress"
export OPTIONS="$OPTIONS --exclude-checkid /check/ftxvalidator" # We lack this on Travis.
# export OPTIONS="$OPTIONS --exclude-checkid /check/metadata" # Comment this out after creating a METADATA.pb file.
# export OPTIONS="$OPTIONS --exclude-checkid /check/description" # Comment this out after creating a DESCRIPTION.en_us.html file.
export OPTIONS="$OPTIONS --exclude-checkid /check/varfont" # Comment this out when making a variable font.
export OPTIONS="$OPTIONS --loglevel INFO --ghmarkdown Fontbakery-check-results.md"
fontbakery check-googlefonts $OPTIONS $OUTPUT_DIR/*.ttf
