# XML_Generator
Wraps podcast episode file in ITEM xml.

I am a language instructor here in Tokyo.  I have managed to incorporate my love of podcasting into my curriculum: At the end of each lesson, I record a podcast episode with each student. Each student’s podcast is hosted from my Dropbox via a private link. Initially, I hand-coded the xml for each episode. PITA. A royal PITA. So, I wrote DLABO.sh.

This was written using all the knowledge I have of programming.


For the record, I stole this bit from the internet:

Math

EstDur=$(echo "($DUR+0.5)/1" | bc);hours=$(echo "($EstDur/3600)" | bc);

minutes=$(echo "(($EstDur/60)%60)" | bc);

seconds=$(echo "($EstDur%60)" | bc);
