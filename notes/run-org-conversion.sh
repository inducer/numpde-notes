#! /bin/bash

#set -x
set -e

unset PYTHONWARNINGS

TARGET_EXT=tex

if test "$NOTES_DEV" = ""; then
  BASENAME="notes-prod"
  sed 's/tasks:t/tasks:nil/' notes.org > notes-prod.org
else
  BASENAME="notes"
fi

set -- ${BASENAME}.org

. orgmk-init

eval $ORGMK -l $(pwd)/orgmk-extra-conf.el \
  $FILE_SRC_ORIG $ORGMK_UPDATE_FLAGS -f org-beamer-export-to-latex \
    || die "Exported file wasn't produced"

# orgmk-update-src-check-diff "$FILE_SRC_ORIG" "$FILE_SRC_UPDT"

if test "$NOTES_DEV" = ""; then
  rm notes-prod.org
  mv "$BASENAME.tex" notes.tex
fi

latexrun --verbose-cmds -O out notes.tex

grep -v '\\showhiddentrue' notes.tex > notes-folded.tex
latexrun --verbose-cmds -O out notes-folded.tex
