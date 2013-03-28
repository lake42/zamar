#!/usr/bin/perl

require "subparseform.lib";
require "zamar.lib";

$root = "$ENV{'DOCUMENT_ROOT'}";
$gigtxt = "/home/2/2/6/1491/1491/www/gig.txt";
$cgiurl = "addgig2.pl?id=1";

#varible set for the zamar lib
$title = "Gig Entry Form";
$phrase = "Enter dates for the performance schedule.";
$item = "rscontinuum@zamarentertainment.com";

($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
$year = 1900 + $year;
$thismonth = ($mon + 1);
$lastmonth = $mon;
if ($thismonth <10) {$thismonth = "0$thismonth";}
if ($lastmonth <10) {$lastmonth = "0$lastmonth";}
if ($mday <10) {$mday = "0$mday";}
$date = "$thismonth/$mday/$year";
@months = ("January","February","March","April","May","June","July","August","September","October","November","December");

&Parse_Form;

sub topper{
print "Content-type: text/html\n\n";
}

$n=$formdata{'id'};
if ($formdata{'id'} eq ""){$n="1";}
if ($n eq "1") {&topper;&htmlhead;&buildnav($item);&pictandinfo($title,$phrase);&gigform;&footer;}
elsif ($n eq "2") {&addnod;&topper;&htmlhead;&buildnav($item);&pictandinfo($title,$phrase);&gigform;&footer;}


sub addnod {
	open(DATA,"gig2.xml");
	@LINES=<DATA>;
	close (DATA);
	$SIZE=@LINES;
	
	open (NEWFILE,">gig2.xml") || die "Can't Open $gigtxt: $!\n";
	for ($i=0;$i<=$SIZE;$i++) {
		$_=$LINES[$i];
		   if (/<!--addnode-->/) {
		   		print NEWFILE "<!--addnode-->\n";
		   		print NEWFILE "<gig>\n";
		   		print NEWFILE "	<nodecreation>$date</nodecreation>\n";
		   		print NEWFILE "	<date>$formdata{'gigdate'}</date>\n";
		   		print NEWFILE "	<details><![CDATA[$formdata{'gigdetails'}\n]]></details>\n";
		   		print NEWFILE "</gig>\n";
		   	#startprinting new node plus addnode tag
			} else { print NEWFILE $_;}
	}
	close (NEWFILE);
}

sub redirect {
 print "Location: $cgiurl\n\n";
 }
