# XML_Generator
Wraps podcast episode file in ITEM xml.

I am a language instructor here in Tokyo.  I have managed to incorporate my love of podcasting into my curriculum: At the end of each lesson, I record a podcast episode with each student. Each student’s podcast is hosted from my Dropbox via a private link. Initially, I hand-coded the xml for each episode. PITA. A royal PITA. So, I wrote DLABO.sh.

This was written using all the knowledge I have of programming.

## Math
For the record, I stole this bit from the internet:

    EstDur=$(echo "($DUR+0.5)/1" | bc);
    hours=$(echo "($EstDur/3600)" | bc);
    minutes=$(echo "(($EstDur/60)%60)" | bc);
    seconds=$(echo "($EstDur%60)" | bc);

## Output and In-Place Editing
Thanks to mcstafford and McDutchie over on Reddit, in-place editing is a thing.

    echo "%s/<\/channel>//g
    w
    q
    " | ex "$RSS";

    echo "%s/<\/rss>//g
    w
    q
    " | ex "$RSS";

    cat << EOF >> "$RSS"
    <item>
        <title>${EPSNO}: ${EPSNM}</title>
        <itunes:subtitle>${EPSSBT}</itunes:subtitle>
        <itunes:author>${AUTHR}</itunes:author>
        <itunes:summary>${EPSSUM}</itunes:summary>
        <enclosure url="http://dl.dropboxusercontent.com${MFL}?dl=1" length="${BYTES}" type="audio/mpeg" />
        <guid>http://dl.dropboxusercontent.com${MFL}?dl=1</guid>
        <itunes:duration>${DRTN}</itunes:duration>
        <pubDate>${DOW}, ${CDATE} ${MNTH} ${PYR} ${TME} +0900</pubDate>
        <itunes:keywords>${KYWRDS}</itunes:keywords>
        <itunes:explicit>${XPLCT}</itunes:explicit>
    </item>
    </channel>
    </rss>
    EOF
    
[Reddit thread](http://www.reddit.com/r/bash/comments/326n0c/refactoringdebugginghalp_command_line_xml/)
