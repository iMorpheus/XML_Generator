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
AUTHR=$(echo "D.L.A.");
echo "Episode Summary: ";
read -e EPSSUM;
echo "Explicit tag. Select from Yes(Explict), No(Not explict) or Clean: ";
read -e XPLCT;

# Keywords
echo '~~~~~~~~~~~~~~~~~Keywords~~~~~~~~~~~~~~';
echo "Add keywords: ";
read -e KYWRDS;

echo "~~~~~~~~~~~~~~~~~~~~RSS FEED~~~~~~~~~~~~~~~";
ls .;
echo "XML File to Edit: ";
read -e RSS;

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
ex "$RSS" <<EOF
/<\/channel>/d
/<\/rss>/d
w
q

EOF

cat << EOF >> "$RSS"
<item>
  <title>${EPSNO}: ${EPSNM}</title>
  <itunes:subtitle>${EPSSBT}</itunes:subtitle>
  <itunes:author>${AUTHR}</itunes:author>
  <itunes:summary>${EPSSUM}</itunes:summary>
  <enclosure url="http://dl.dropboxusercontent.com${MFL}?dl=1" length="${BYTES}" type="audio/mp4a-latm" />
  <guid>http://dl.dropboxusercontent.com${MFL}?dl=1</guid>
  <itunes:duration>${DRTN}</itunes:duration>
  <pubDate>${DOW}, ${CDATE} ${MNTH} ${PYR} ${TME} +0900</pubDate>
  <itunes:keywords>${KYWRDS}</itunes:keywords>
  <itunes:explicit>${XPLCT}</itunes:explicit>
</item>

</channel>
</rss>

EOF

}

DLABO
