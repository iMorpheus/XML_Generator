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


DUR=$(afinfo $M4A | grep "estimated duration" | grep -Eo '[0-9].{1,10}');

# file type audio/mp4a-latm auto added at generation.
echo "Media file link: ";
read -e TEMPMFL;
MFL=$(echo $TEMPMFL | grep https | sed s/https/http/ | grep www | sed s/www/dl/ | grep dropbox | sed s/dropbox/dropboxusercontent/ | grep '?dl=0' | sed s/?dl=0/?dl=1/);

# Episode Information:
echo '~~~~~~~~~~~~~~~~~~~Episode Information~~~~~~~~~~~~~~';
EPSNO=$( echo $TEMPMFL | grep -Eo '[0-9][0-9][0-9]');
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
echo  '<item>';
echo  '\r<title>'$EPSNO':' $EPSNM'</title>';
echo '\r<itunes:subtitle>'$EPSSBT'</itunes:subtitle>';
echo  '\r<itunes:author>'$AUTHR'</itunes:author>';
echo '\r<itunes:summary>'$EPSSUM'</itunes:summary>';
echo '\r<enclosure url="'$MFL'" length="'$BYTES'" type="audio/mp4a-latm" />';
echo '\r<guid>'$MFL'</guid>';

echo '\r<itunes:duration>'$DRTN'</itunes:duration>';
echo  '\r<pubDate>'$DOW', '$CDATE' '$MNTH' '$PYR' '$TME '+0900</pubDate>';
echo  '\r<itunes:keywords>'$KYWRDS'</itunes:keywords>';
echo  '\r<itunes:explicit>'$XPLCT'</itunes:explicit>';
echo  '\r</item>';
);
echo $XML > xml.txt;
clear;
more xml.txt | pbcopy;
}

DLABO
