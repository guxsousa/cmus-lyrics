#!/bin/bash -
#===============================================================================
#
#          FILE: LyricsGet
#
#         USAGE: ./LyricsGet.sh 'artist' 'title' 'album'
#
#   DESCRIPTION: Obtains song info either from cmus-remote or from user
#   and searches into a lyric retriever site.
#
#       OPTIONS: ---
#  REQUIREMENTS: curl, tr
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Gus Sousa (@guxsousa),
#  ORGANIZATION: github.com/guxsousa
#       CREATED: 18/08/2017 04:04:51
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error




#[0] Set Input Variables -----------------------------------------------------

ARTIST=$1
TITLE=$2
ALBUM=$3

ARTIST_CONVERTED=`echo $ARTIST | \
				sed 's/[_ ()]//g' | \
				awk '{print tolower($0)}' | \
				sed 's/[^a-z]//g'`
TITLE_CONVERTED=`echo $TITLE | \
				sed 's/[_ ()]//g' | \
				awk '{print tolower($0)}' | \
				sed 's/[^a-z]//g'`
ALBUM_CONVERTED=`echo $ALBUM | \
				sed 's/[_ ()]//g' | \
				awk '{print tolower($0)}' | \
				sed 's/[^a-z]//g'`




#[1] Retrieve Information ----------------------------------------------------

URL="https://www.azlyrics.com/lyrics/$ARTIST_CONVERTED/$TITLE_CONVERTED.html"

USER_AGENT="User-Agent: Mozilla/5.0 (X11; Linux i686) AppleWebKit/"+
"537.36 (KHTML, like Gecko) Chrome/29.0.1535.3 Safari/537.36"

ANSWER=`curl -s $URL -H 'Accept: text/html,application/xhtml+xml,application"+
"/xml;q=0.9,*/*;q=0.8' -H 'Host: www.azlyrics.com' -H "$USER_AGENT"`

if [ "$?" -ne "0" ]
then
	exit 1
fi





#[2] Parse Information -------------------------------------------------------

GET_WEB_INFO=`echo "$ANSWER" | w3m -dump -T text/html`

GET_SITE_INFO=`echo $ANSWER | tr -s '\r\n' ' '`

GET_SITE_INFO=`echo "$GET_SITE_INFO" | sed "s/^.*<!-- Usage of azlyrics.com\
 content by any third-party lyrics provider is prohibited by our licensing\
 agreement. Sorry about that. -->//" | sed "s/<!-- MxM banner.*$//"`

TEXT_LYRIC=`echo "$GET_SITE_INFO" | sed "s/<\/div>//" | sed "s/<br>/\\n/"`




#[3] Print Results -----------------------------------------------------------

nolyric="WHAT'S HOT?" # Error Page / Fail Method Display

printf "\033c"
echo ""
printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
echo "song: " $TITLE
echo "artist: " $ARTIST
echo "album: " $ALBUM
printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
echo ""

if echo "$GET_WEB_INFO" | grep -q "$nolyric"; then
  echo "no lyrics found";
else
  echo "$TEXT_LYRIC" | w3m -dump -T text/html
fi
printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -


