#!/bin/bash -
#===============================================================================
#
#          FILE: CmusNowLyrics.sh
#
#         USAGE: ./CmusNowLyrics.sh
#
#   DESCRIPTION: Obtains song info playing in cmus
#       OPTIONS:
#  REQUIREMENTS:
#          BUGS:
#         NOTES: + adjust relative/abslute path
#        AUTHOR: based on the script by Michael Chris Lopez (mcchrish)
#  ORGANIZATION:
#       CREATED:
#      REVISION:
#===============================================================================

set -o nounset                  # Treat unset variables as an error!/bin/bash



export PATH="/usr/local/bin:/usr/bin:/bin:$PATH"

state=$(cmus-remote -C status | sed -n 1p | cut -d " " -f2)

track=$(cmus-remote -C "format_print %{title}")
artist=$(cmus-remote -C "format_print %{artist}")
album=$(cmus-remote -C "format_print %{album}")

if [ "$state" = "playing" ] || [ "$state" = "paused" ]; then
  if [ "$state" = "playing" ]; then
    state_icon="▸"
    echo "$state_icon $track ❲ $album ❳ ⁃ $artist "
  else
    state_icon="▪︎"
    echo "$state_icon $track - $album | $artist"
  fi
  printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
  echo ""
  sh LyricsGet.sh "$artist" "$track" "$album"
else
  echo "no cmus"
fi
