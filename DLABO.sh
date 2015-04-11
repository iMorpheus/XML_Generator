#!/bin/sh
function DLABO()
{

# echo '~~~~~~~~~~~~~~~~~~~Date and Time~~~~~~~~~~~~~~';
DOW=$(date +"%a");
CDATE=$(date +"%d");
MNTH=$(date +"%b");
PYR=$(date +"%Y");
TME=$(date +"%H:%M:%S");

# File Info
echo '~~~~~~~~~~~~~~~~~~~Audio File Data~~~~~~~~~~~~~~';
echo "Length in bytes for file: "
ls *.m4a;
read -e M4A;
BYTES=$(afinfo $M4A | grep "audio bytes" | grep -Eo '[0-9]{1,15}');
open -R $M4A;


DUR=$(afinfo $M4A | grep "estimated duration" | grep -Eo '[0-9].{1,11}');

# file type audio/mp4a-latm auto added at generation.
echo "Media file link: ";
read -e TEMPMFL;
MFL=$(echo "$TEMPMFL" | sed s/https.*com// | sed s/?.*//);

# Episode Information:
echo '~~~~~~~~~~~~~~~~~~~Episode Information~~~~~~~~~~~~~~';
EPSNO=$(afinfo $M4A | grep "File:" | grep -Eo '[0-9][0-9][0-9]');
echo "Episode name: ";
read -e EPSNM;
echo "Episode subtitle: ";
read -e EPSSBT;
AUTHR=$(echo "Derek L. Arnwine");
echo "Episode Summary: ";
read -e EPSSUM;
echo "Explicit tag. Select from Yes(Explict), No(Not explict) or Clean: ";
read -e XPLCT;

# Keywords
echo '~~~~~~~~~~~~~~~~~Keywords~~~~~~~~~~~~~~';
echo "Add keywords: ";
read -e KYWRDS;
# ----------------- END DATA COLLECTION -------------------
# Output Tester: Date, Time and File Info
# echo $DOW, $CDATE, $MNTH, $TME, $RNGTM, $BYTES;
# Output Tester: Episode Info
# echo $EPSNO, $EPSNM, $EPSSBT, $AUTHR, $EPSSUM, $XPLCT;

# Math
EstDur=$(echo "($DUR+0.5)/1" | bc);
hours=$(echo "($EstDur/3600)" | bc);
minutes=$(echo "(($EstDur/60)%60)" | bc);
seconds=$(echo "($EstDur%60)" | bc);
# echo "00:$minutes:$seconds";
DRTN=$(printf "%02d:%02d:%02d\n" $hours $minutes $seconds);


# ------------------ XML GENERATOR PROPER -------------------
XML=$(
printf "<item>\n";
printf "<title>%b: %b</title>\n" "$EPSNO" "$EPSNM";
printf "<itunes:subtitle>%b</itunes:subtitle>\n" "$EPSSBT";
printf "<itunes:author>%b</itunes:author>\n" "$AUTHR";
printf "<itunes:summary>%b</itunes:summary>\n" "$EPSSUM";
printf "<enclosure url=\"http://dl.dropboxusercontent.com%b?dl=1\" length=\"%b\" type=\"audio/mp4a-latm\" />\n" "$MFL" "$BYTES";
printf "<guid>http://dl.dropboxusercontent.com%b?dl=1</guid>\n" "$MFL";
printf "<itunes:duration>%b</itunes:duration>\n" "$DRTN";
printf "<pubDate>%b, %b %b %b %b +0900</pubDate>\n" "$DOW" "$CDATE" "$MNTH" "$PYR" "$TME";
printf "<itunes:keywords>%b</itunes:keywords>\n" "$KYWRDS";
printf "<itunes:explicit>%b</itunes:explicit>\n" "$XPLCT";
printf "</item>\n";
);

echo "$XML" > xml.txt;
clear;
more xml.txt | pbcopy;

echo "$XML";
# echo "%s/<\/channel>/$XML/
# w
# q
# " | ex "$F_XML";
}

DLABO
