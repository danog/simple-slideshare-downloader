#!/bin/bash
# Simple slideshare downloader
# By Daniil Gentili (https://daniil.it)
# Licensed under GPLv3
# Copyright 2016 Daniil Gentili

#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.

#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.

#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

echo "Simple slideshare downloader   Copyright (C) 2016  Daniil Gentili.
This program comes with ABSOLUTELY NO WARRANTY; for details see 
https://github.com/danog/git-reset-repo/blob/master/LICENSE.
This is free software, and you are welcome to redistribute it
under certain conditions: see https://github.com/danog/simple-slideshare-downloader/blob/master/LICENSE.
"

usage() {
	echo "Usage: $0 URL"
	exit
}
[ -z "$*" ] && usage

for f in $*;do
	echo "Downloading $f..."
	PAGE="$(curl -s "$f")"
	URL=$(echo "$PAGE" | sed '/data-normal/!d;s/.*data-normal="//;s/\s.*//g' | tr -s '\n' ' ')
	TITLE=$(echo "$PAGE" | sed '/^[<]title[>]/!d;s/^[<]title[>]//g;s/[<]\/title[>]$//g')
	MD5=$(echo "$TITLE" | md5sum | sed 's/\s.*//g')
	mkdir $MD5
	for url in $URL;do
		curl -s "$url" -o $MD5"/"$(echo "$url" | sed 's/\?.*//g;s/.*\///g')
	done
	convert $MD5"/*" -gravity South -annotate 0 '%f' "$TITLE".pdf
	rm -r $MD5
	echo "Saved in $TITLE.pdf"
done

echo "Bye!"
exit
