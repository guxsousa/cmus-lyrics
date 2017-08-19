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
				sed 's/[_()]//g' | \
				awk '{print tolower($0)}' | \
				sed 's/[^a-z]/-/g'`
TITLE_CONVERTED=`echo $TITLE | \
				sed 's/[_()]//g' | \
				awk '{print tolower($0)}' |\
				sed 's/[^a-z]/-/g'`
ALBUM_CONVERTED=`echo $ALBUM | \
				sed 's/[_()]//g' | \
				awk '{print tolower($0)}' | \
				sed 's/[^a-z]/-/g'`

API='YOURAPIFROMMUSIXMATCHDEVELOPER'

USER_AGENT="User-Agent: Mozilla/5.0 (X11; Linux i686) AppleWebKit/\
537.36 (KHTML, like Gecko) Chrome/29.0.1535.3 Safari/537.36"




#[1] Retrieve Information ---------------------------------------------------

# Using <matcher.track.get> method
URL="http://api.musixmatch.com/ws/1.1/matcher.track.get?\
apikey=$API\
&q_artist=$ARTIST_CONVERTED\
&q_track=$TITLE_CONVERTED\
&q_album=$ALBUM_CONVERTED\
&page_size=1\
&page=1\
&s_track_rating=desc\
&format=json\
&f_has_lyrics"

# Using <track.search> method
URLb="http://api.musixmatch.com/ws/1.1/track.search?\
apikey=$API\
&q_artist=$ARTIST_CONVERTED\
&q_track=$TITLE_CONVERTED\
&page_size=1\
&page=1\
&s_track_rating=desc\
&format=json\
&f_has_lyrics"

ANSWER=`curl -s $URL -H 'Accept: text/html' \
				-H 'Accept: application/json' \
				-H 'Content-Type: application/json' \
				-H 'Accept: application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' \
				-H '$USER_AGENT'`

LYRID=`echo "$ANSWER" | jq -e -r '.[].body.track.track_id'`
GET_STATUS=`echo "$ANSWER" | jq -e -r '.[].header.status_code'`

if [ "$?" -ne "0" ]
then
	exit 1
fi


if test "$GET_STATUS" = "200"
then
     echo "Good."
else
    echo "Not found."

		ANSWER=`curl -s $URLb -H 'Accept: text/html' \
				-H 'Accept: application/json' \
				-H 'Content-Type: application/json' \
				-H 'Accept: application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' \
				-H '$USER_AGENT'`
		GET_STATUS=`echo "$ANSWER" | jq -e -r '.[].header.status_code'`
		LYRID=`echo "$ANSWER" | jq -e -r '.[].body.track_list[].track.track_id'`

		if test "$GET_STATUS" = "200"
		then
				echo "Good."
    else
				echo "Not found."
    fi
fi




#[1] Retrieve Information ----------------------------------------------------

URL="https://api.musixmatch.com/ws/1.1/track.lyrics.get?\
format=jsonp\
&callback=jsonp\
&track_id=$LYRID\
&apikey=$API"

ANSWER=`curl -s -X GET --header 'Accept: text/plain' $URL`

if [ "$?" -ne "0" ]
then
	exit 1
fi




#[2] Parse Information -------------------------------------------------------

GET_SITE_INFO=$(echo "$ANSWER" | \
				sed 's/jsonp//g' | \
				sed 's/(/[/g' | \
				sed 's/)/]/g' | \
				sed 's/;//g')
echo $GET_SITE_INFO > tmps.txt

TEXT_LYRIC=$(echo $GET_SITE_INFO | \
				jq '.[0].message.body.lyrics.lyrics_body')
TEXT_LYRIC=`echo "$TEXT_LYRIC" | \
				sed "s/This Lyrics is NOT for Commercial use//" | \
				sed "s/*[1-9.]*//" | \
				sed "s/\[.*].//"`
# also works: %s/\[[0-9.]*\]/




#[3] Print Results -----------------------------------------------------------

printf "\033c"
echo ""
printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
echo "song: " $TITLE
echo "artist: " $ARTIST
printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
echo ""

printf "$TEXT_LYRIC"

# Copyright Requirement (Musixmatch API Legal)
echo ""
COPYSONG=$(echo "$GET_SITE_INFO" | \
				jq '.[0].message.body.lyrics.lyrics_copyright')
echo $COPYSONG

# Tracker for Statistics (Musixmatch API Legal)
echo ""
URL="http://tracking.musixmatch.com/t1.0/AMa6hJCIEzn1v8RuOP"
ANSWER=`curl -s $URL \
				-H 'Accept: text/html,application/xhtml+xml,' \
				-H 'application/xml;q=0.9,*/*;q=0.8'`
echo "$ANSWER"
