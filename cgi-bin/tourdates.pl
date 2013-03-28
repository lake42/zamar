#!/usr/bin/perl -w

require "zamar.lib";

open(DATA,"gig.xml");
@msglines = <DATA>;
close(DATA);

$flag = 0;

#varible set for the zamar lib
$title = "Russell Sledge's $br Performance Schedule";
$titlehead = "Russell Sledge's Performance Schedule";
$phrase = "This is Russell Sledge's up-to-date performance schedule.";
$item = "Dates";

print "Content-type: text/html\n\n";
&htmlhead($titlehead);
&buildnav($item);
&pictandinfo($title,$phrase);
&starttable;
#this parses the xml file, excluding non-needed elements
	for ($i=0; $i<@msglines; $i++) {
		if ($msglines[$i] =~ /<\?xml version=\"1.0\"\?>/) {$dummy[$i] = $1; $flag=1;}
			elsif  ($msglines[$i] =~ /<!--addnode-->/){$dummy[$i] = $1; $flag=1;}
			elsif  ($msglines[$i] =~ /<gig>/){$dummy[$i] = $1; $flag=1;}
			elsif ($msglines[$i] =~ /<nodecreation>(.*)<\/nodecreation>/) {$dummy[$i] = $1; $flag=1;}
			elsif ($msglines[$i] =~ /<date>(.*)<\/date>/) {$date[$i] = $1; print $rule.$nn.$wrap1.$nn.$s1.$date[$i].$s2.$br.$nn;}
			elsif ($msglines[$i] =~ /<details><\!\[CDATA\[(.*)\]\]><\/details>/) {$details[$i] = $1; print $p.$details[$i].$br.$wrap2.$nn;}
			elsif  ($msglines[$i] =~ /<\/gig>/){$dummy[$i] = $1;}
			elsif  ($msglines[$i] =~ /<\/russellgigs>/){$dummy[$i] = $1;}
	}
&endtable;
&buildnav($item);
&footer;
