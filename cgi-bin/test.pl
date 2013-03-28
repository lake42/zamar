#!/usr/bin/perl
use CGI::Carp qw(fatalsToBrowser);
##########################################################################
#  ServerCheck Version 2.10
#
#
#  Created:	May 01, 1999
#  Updated:	Mar 08, 2008
#  Copyright:	1999 - 2008 Virtual Solutions. All Rights Reserved
#
#  URL:		http://www.monster-submit.com/servercheck/
##########################################################################

##########################################################################
#  Copyright Notice
##########################################################################
#  Any redistribution of this script without the expressed written consent
#  of Virtual Solutions is strictly prohibited. Copying any of the code
#  contained within this script and claiming it as your own is also
#  prohibited. You may not remove any of these header notices. By using
#  this code you agree to indemnify Virtual Solutions from any liability
#  that might arise from its use.

#  If this URL is not properly defined on your server, then edit this variable
#  as the URL pointing to the servercheck.cgi script.
my $script_url = "http://$ENV{'HTTP_HOST'}$ENV{'SCRIPT_NAME'}";

##############################################################
#  Installation
##############################################################
#  1. Edit path to Perl at top of script if it differs on your server. Usual and
#  default path is [/usr/bin/perl]. However, on some servers it may be
#  /usr/local/bin/perl. If in doubt, then refer to a script on your server that
#  does work, or ask your web host.
#  2. FTP upload script to server in ASCII (text), and CHMOD 755 (rwxr-xr-x).
#  Then, rename to servercheck.cgi (or servercheck.pl if your server uses
#  the .pl extension for CGI-Perl scripts).

##############################################################
#  Do NOT change or alter the code below!
##############################################################

use strict;
print "Content-type: text/html\n\n";

use vars qw ($action $subaction);

eval {
	($0 =~ m,(.*)/[^/]+,) && unshift(@INC, $1);
	require 5.004;
};
if ($@) {
	print $@;
	exit;
}

my @mod;
eval { &main; };
if ($@) { print $@; }
exit;

###############################################
# Main
###############################################
sub main {

($action, $subaction) = split(/\&/, $ENV{'QUERY_STRING'});
$subaction = "all" if ! $subaction;

CASE: {
	($action eq "header") and do { &top_header; last CASE; };
	($action eq "compile") and do { &compile; last CASE; };
	&body;
}
}

###############################################
# Body
###############################################
sub body {

print <<HTML;
<html>

<frameset rows=20%,80%>
	<frame src="$script_url?header" name="top" scrolling="no">
	<frame src="$script_url?compile" name="bottom">
</frameset>

</html>
HTML
}

###############################################
# Compile
###############################################
sub compile {

my @usr = qw/REMOTE_ADDR REMOTE_HOST HTTP_USER_AGENT HTTP_ACCEPT_LANGUAGE HTTP_X_FORWARDED_FOR HTTP_VIA/;
my @svr = qw/SERVER_SOFTWARE GATEWAY_INTERFACE DOCUMENT_ROOT SERVER_PROTOCOL SERVER_SIGNATURE 
PATH HTTP_CONNECTION REMOTE_PORT SERVER_ADDR SCRIPT_NAME SCRIPT_FILENAME SERVER_NAME HTTP_PRAGMA 
REQUEST_URI SERVER_PORT HTTP_HOST SERVER_ADMIN/;

my %server;

$server{'SERVER_OS1'}	= (ucfirst($^O) ? ucfirst($^O) : "<font color=\"red\">Unknown</font>");
$server{'SERVER_OS2'}	= (`uname -r` ? `uname -r` : "<font color=\"red\">Unknown</font>");
$server{'SERVER_VER'}	= (server('version') ? server('version') : "<font color=\"red\">Unknown</font>");
$server{'SERVER_CPU'}	= (server('cpuinfo') ? server('cpuinfo') : "<font color=\"red\">Unknown</font>");
$server{'SERVER_MEM'}	= (server('meminfo') ? server('meminfo') : "<font color=\"red\">Unknown</font>");
$server{'SERVER_UPT'}	= (`uptime` ? `uptime` : "<font color=\"red\">Unknown</font>");
$server{'SERVER_DSK'}	= (`df` ? `df` : "Unknown");
if ($server{'SERVER_DSK'}) {
	my @lines = split(/\n/, $server{'SERVER_DSK'});
	my $num = (@lines + 1);
	$server{'SERVER_DSK'} = qq~			<tr>
				<td width="30%" class="cellstyle3"><nobr><font class="fontstyle3">Server Disk Space</font></nobr></td>
				<td width="70%" class="cellstyle4"><textarea rows="$num" cols="75" wrap="off">$num-$server{'SERVER_DSK'}</textarea></td>
			</tr>~;
}

my $time	= &get_time();
my $dir	= `pwd`;

&bottom_header;

if (($subaction == 1) || ($subaction eq "all")) {
	print <<HTML;
<table bgcolor="#7384BD" width="90%" cellpadding="0" cellspacing="0" border="0">
	<tr>
		<th>
		<center>
		<table bgcolor="#C0C0C0" width="100%" cellpadding="4" cellspacing="1" border="0">
			<tr>
				<th colspan="2" width="95%" class="cellstyle2"><font class="fontstyle2">Server Information</font>
				<a class="special" href="#0"><sup>TOP</sup></a></th>
			</tr>
			<tr>
				<td width="30%" class="cellstyle3"><nobr><font class="fontstyle3">Name</font></nobr></td>
				<td width="70%" class="cellstyle4"><font class="fontstyle4">$ENV{"SERVER_NAME"}</font></td>
			</tr>
			<tr>
				<td width="30%" class="cellstyle3"><nobr><font class="fontstyle3">IP Address</font></nobr></td>
				<td width="70%" class="cellstyle4"><font class="fontstyle4">$ENV{"SERVER_ADDR"}</font></td>
			</tr>
			<tr>
				<td width="30%" class="cellstyle3"><nobr><font class="fontstyle3">Server Software</font></nobr></td>
				<td width="70%" class="cellstyle4"><font class="fontstyle4">$server{"SERVER_OS1"} $server{"SERVER_OS2"}<p>
				$server{"SERVER_VER"}</font></td>
			</tr>
			<tr>
				<td width="30%" class="cellstyle3"><nobr><font class="fontstyle3">Server CPU</font></nobr></td>
				<td width="70%" class="cellstyle4"><font class="fontstyle4">$server{"SERVER_CPU"}</font></td>
			</tr>
			<tr>
				<td width="30%" class="cellstyle3"><nobr><font class="fontstyle3">Server Memory</font></nobr></td>
				<td width="70%" class="cellstyle4"><font class="fontstyle4">$server{"SERVER_MEM"}</font></td>
			</tr>
$server{'SERVER_DSK'}
			<tr>
				<td width="30%" class="cellstyle3"><nobr><font class="fontstyle3">Server Uptime / Load Average</font></nobr></td>
				<td width="70%" class="cellstyle4"><font class="fontstyle4">$server{"SERVER_UPT"}</font></td>
			</tr>
			<tr>
				<td width="30%" class="cellstyle3"><nobr><font class="fontstyle3">Current Server Local Time</font></nobr></td>
				<td width="70%" class="cellstyle4"><font class="fontstyle4">$time</font></td>
			</tr>
			<tr>
				<td width="30%" class="cellstyle3"><nobr><font class="fontstyle3">Current Working Directory Path</font></nobr></td>
				<td width="70%" class="cellstyle4"><font class="fontstyle4">$dir</font></td>
			</tr>
		</table>
		</center>
		</th>
	</tr>
</table><p>
HTML
}

if (($subaction == 2) || ($subaction eq "all")) {
	print <<HTML;
<table bgcolor="#7384BD" width="90%" cellpadding="0" cellspacing="0" border="0">
	<tr>
		<th>
		<center>
		<table bgcolor="#C0C0C0" width="100%" cellpadding="4" cellspacing="1" border="0">
			<tr>
				<th colspan="2" width="95%" class="cellstyle2"><font class="fontstyle2">Remote User Environment Variables</font>
				<a class="special" href="#0"><sup>TOP</sup></a></th>
			</tr>
HTML

foreach (@usr) {
	$ENV{$_} =~ s/<[\/a-z]+>//gi;
	$ENV{$_} =~ s/\n//g;
	$ENV{$_} = qq~<font color="red">Unknown</font>~ if ! $ENV{$_};
	print qq~			<tr>\n~;
	print qq~				<td width="30%" class="cellstyle3"><font class="fontstyle3">$_</font></td>\n~;
	print qq~				<td width="70%" class="cellstyle4"><font class="fontstyle4">$ENV{$_}</font></td>\n~;
	print qq~			</tr>\n~;
}
print <<HTML;
		</table>
		</center>
		</th>
	</tr>
</table><p>

HTML
}

if (($subaction == 3) || ($subaction eq "all")) {
	my $textarea = "Perl Version: $]\n";
	$textarea .= join("\n", split(/\s+/, qx/whereis perl/));
	my @lines = split(/\n/, $textarea);
	my $num = (@lines + 1);
	print <<HTML;
<table bgcolor="#7384BD" width="90%" cellpadding="0" cellspacing="0" border="0">
	<tr>
		<th>
		<center>
		<table bgcolor="#C0C0C0" width="100%" cellpadding="4" cellspacing="1" border="0">
			<tr>
				<th colspan="2" width="100%" class="cellstyle2"><font class="fontstyle2">Perl Program</font>
				<a class="special" href="#0"><sup>TOP</sup></a></th>
			</tr>
			<tr>
				<th bgcolor="#FFFFFF">
				<center>
				<form>
				<textarea rows="$num" cols="80" wrap="off">
$textarea
				</textarea>
				</form>
				</center>
				</th>
			</tr>
		</table>
		</center>
		</th>
	</tr>
</table><p>

HTML
}

if (($subaction == 4) || ($subaction eq "all")) {
	my $textarea .= join("\n", split(/\s+/, qx/whereis sendmail/));
	my @lines = split(/\n/, $textarea);
	my $num = (@lines + 1);
	print <<HTML;
<table bgcolor="#7384BD" width="90%" cellpadding="0" cellspacing="0" border="0">
	<tr>
		<th>
		<center>
		<table bgcolor="#C0C0C0" width="100%" cellpadding="4" cellspacing="1" border="0">
			<tr>
				<th colspan="2" width="95%" class="cellstyle2"><font class="fontstyle2">Mail Program</font>
				<a class="special" href="#0"><sup>TOP</sup></a></th>
			</tr>
			<tr>
				<th bgcolor="#FFFFFF">
				<center>
				<form>
				<textarea rows="$num" cols="80" wrap="off">
$textarea
				</textarea>
				</form>
				</center>
				</th>
			</tr>
		</table>
		</center>
		</th>
	</tr>
</table><p>
HTML
}

if (($subaction == 5) || ($subaction eq "all")) {
	print <<HTML;
<table bgcolor="#7384BD" width="90%" cellpadding="0" cellspacing="0" border="0">
	<tr>
		<th>
		<center>
		<table bgcolor="#C0C0C0" width="100%" cellpadding="4" cellspacing="1" border="0">
			<tr>
				<th colspan="2" width="95%" class="cellstyle2"><font class="fontstyle2">Server Environment Variables</font>
				<a class="special" href="#0"><sup>TOP</sup></a></th>
			</tr>
HTML
foreach (@svr) {
	$ENV{$_} =~ s/<[\/a-z]+>//gi;
	$ENV{$_} =~ s/\n//g;
	$ENV{$_} = qq~<font color="red">Unknown</font>~ if ! $ENV{$_};
	print qq~			<tr>\n~;
	print qq~				<td width="30%" class="cellstyle3"><font class="fontstyle3">$_</font></td>\n~;
	print qq~				<td width="70%" class="cellstyle4"><font class="fontstyle4">$ENV{$_}</font></td>\n~;
	print qq~			</tr>\n~;
}
print <<HTML;
		</table>
		</center>
		</th>
	</tr>
</table><p>

HTML
}

if (($subaction == 6) || ($subaction eq "all")) {
	my $libraries;
	eval { require CGI };
	if ($@) { $libraries .= "				<font color=\"red\">Library CGI not installed</font><br>\n"; }
	else { $libraries .= "				<font color=\"green\">Library CGI v$CGI::VERSION installed</font><br>\n"; }
	eval { require DBI };
	if ($@) { $libraries .= "				<font color=\"red\">Library DBI not installed</font><br>\n"; }
	else { $libraries .= "				<font color=\"green\">Library DBI v$DBI::VERSION installed</font><br>\n"; }
	eval { require LWP };
	if ($@) { $libraries .= "				<font color=\"red\">Library LWP not installed</font><br>\n"; }
	else { $libraries .= "				<font color=\"green\">Library LWP v$LWP::VERSION installed</font><br>\n"; }
	eval { require LWP::Simple };
	if ($@) { $libraries .= "				<font color=\"red\">Library LWP::Simple not installed</font><br>\n"; }
	else { $libraries .= "				<font color=\"green\">Library LWP::Simple v$LWP::Simple::VERSION installed</font><br>\n"; }
	eval { require LWP::UserAgent };
	if ($@) { $libraries .= "				<font color=\"red\">Library LWP::UserAgent not installed</font><br>\n"; }
	else { $libraries .= "				<font color=\"green\">Library LWP::UserAgent v$LWP::VERSION installed</font><br>\n"; }
	eval { require mod_perl };
	if ($@) { $libraries .= "				<font color=\"red\">Library mod_perl not installed</font><br>\n"; }
	else { $libraries .= "				<font color=\"green\">Library mod_perl v$mod_perl::VERSION installed</font><br>\n"; }
	print <<HTML;
<table bgcolor="#7384BD" width="90%" cellpadding="0" cellspacing="0" border="0">
	<tr>
		<th>
		<center>
		<table bgcolor="#C0C0C0" width="100%" cellpadding="4" cellspacing="1" border="0">
			<tr>
				<th colspan="2" width="95%" class="cellstyle2"><font class="fontstyle2">Installed Perl Libraries</font>
				<a class="special" href="#0"><sup>TOP</sup></a></th>
			</tr>
			<tr>
				<td bgcolor="#FFFFFF">
$libraries
				</td>
			</tr>
		</table>
		</center>
		</th>
	</tr>
</table><p>

HTML
}

if (($subaction == 7) || ($subaction eq "all")) {
	my @list;
	use File::Find;
	my (%done, $dir);
	find (\&compile_modules, grep { -r and -d } @INC);
	@mod = grep (! $done{$_}++, @mod);
	foreach $dir (sort { length $b <=> length $a } @INC) { foreach (@mod) { next if s,^\Q$dir,,; } }
	foreach (sort(@mod)) { s,^/(.*)\.pm$,$1,; s,/,::,g; push(@list, $_); }
	my $num = ($#mod + 1);
	print <<HTML;
<table bgcolor="#7384BD" width="90%" cellpadding="0" cellspacing="0" border="0">
	<tr>
		<th>
		<center>
		<table bgcolor="#C0C0C0" width="100%" cellpadding="4" cellspacing="1" border="0">
			<tr>
				<th colspan="2" width="95%" class="cellstyle2"><font class="fontstyle2">Installed Perl Modules[$num]</font>
				<a class="special" href="#0"><sup>TOP</sup></a></th>
			</tr>
			<tr>
				<td width="50%" bgcolor="#FFFFFF">
HTML

my $index;
for ($index = 0; $index < ($num / 2); $index++) {
	print qq~				<a class="special" href="http://search.cpan.org/search?module=$list[$index]">\n~;
	print qq~				~;
	print ($index + 1);
	print qq~. $list[$index]</a><br>\n~;
}

print <<HTML;
				</td>
				<td width="50%" bgcolor="#FFFFFF">

HTML

my $index;
for ($index = (int($num / 2) + 1); $index < $num; $index++) {
	print qq~				<a class="special" href="http://search.cpan.org/search?module=$list[$index]">\n~;
	print qq~				~;
	print ($index + 1);
	print qq~. $list[$index]</a><br>\n~;
}

print <<HTML;
				</td>
			</tr>
		</table>
		</center>
		</th>
	</tr>
</table>
HTML
}

print <<HTML;
</center>

</body>
</html>
HTML
}

########################################################
# Top Header
########################################################
sub top_header {

print <<HTML;
<html>
<head>
<title>Virtual Solutions : ServerCheck</title>
<meta name="Author" content="Virtual Solutions at http://www.monster-submit.com/">
<meta name="Copyright" content="(c) Copyright 1999 - 2008 Virtual Solutions. All Rights Reserved.">
<!-- ServerCheck from Virtual Solutions at http://www.monster-submit.com/ -->
<style>
.link {
	color:#7384BD; font-family: arial, helvetica, sans-serif; font-weight:bold; font-size:10px; text-decoration: none;
}
.link:hover {
	color:#7384BD; font-family: arial, helvetica, sans-serif; font-weight:bold; font-size:10px; text-decoration: underline;
}
.none {
	color:#000000; background-color: #FFFFFF; font-weight:none; text-decoration: none;
}
.special {
	color:#7294AF; text-decoration: none;
}
.special:hover {
	color:#C8D1D7; text-decoration: underline;
}
.special:visited {
	color:#7294AF; text-decoration: none;
}
.button {
	color:#000000; background-color: #C8D1D7; font-weight:none; text-decoration: none;
}
input, select, textarea	{
	color:#000000; background-color: #C8D1D7; font-weight:none; text-decoration: none;
}
.cellstyle1	{
	background-color: #C8D1D7;
}
.cellstyle2	{
	background-color: #DEE3E7;
}
.cellstyle3	{
	background-color: #EFEFEF;
}
.cellstyle4	{
	background-color: #FFFFFF;
}
.cellstyle5	{
background-color: #FFFFFF;
}
.cellstyle6c1 {
	background-color: red;
}
.cellstyle6b1 {
	background-color: #FFFFFF;
}
.cellstyle6c2 {
	background-color: green;
}
.cellstyle6b2 {
	background-color: #FFFFFF;
}
.cellstyle6c3 {
	background-color: yellow;
}
.cellstyle6b3 {
	background-color: #FFFFFF;
}
.fontstyle1	{
	color: #FFFFFF; font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 16px;
}
.fontstyle2	{
	color: #000000; font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 12px;
}
.fontstyle3	{
	color: #006699; font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10px;
}
.fontstyle4	{
	color: #006699; font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10px;
}
.fontstyle5	{
	color: #006699; font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10px;
}
.fontstyle6c1 {
	color: #FFFFFF; font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 12px;
}
.fontstyle6b1 {
	color: red; font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 12px;
}
.fontstyle6c2 {
	color: #FFFFFF; font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 12px;
}
.fontstyle6b2 {
	color: green; font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 12px;
}
.fontstyle6c3 {
	color: #000000; font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 12px;
}
.fontstyle6b3 {
	color: #000080; font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 12px;
}
body {
	background-color:#E5E5E5;
	scrollbar-face-color: #C8D1D7; scrollbar-highlight-color: #EAF0F7;
	scrollbar-shadow-color: #95AFC4; scrollbar-3dlight-color: #D6DDE2;
	scrollbar-arrow-color: #006699; scrollbar-track-color: #EFEFEF;
	scrollbar-darkshadow-color: #7294AF;
}
</style>
</head>

<body bgcolor="#E5E5E5" text="#000080">

<center>
<table bgcolor="#7384BD" width="100%" cellpadding="0" cellspacing="0" border="0">
	<tr>
		<th>
		<center>
		<table bgcolor="#C0C0C0" width="100%" cellpadding="4" cellspacing="1" border="0">
			<tr>
				<th class="cellstyle1"><font class="fontstyle1"><a class="special" href="http://www.monster-submit.com/servercheck/" 
				target="bottom">Powered by ServerCheck [Version 2.10]</a>
				&copy; Copyright 1999 - 2008 Virtual Solutions. All Rights Reserved.
				</font></th>
			</tr>
		</table>
		</center>
		</th>
	</tr>
</table><p>

<a class="special" href="$script_url?compile" target="bottom">Show All</a> | 
<a class="special" href="$script_url?compile&1" target="bottom">Server Information</a> | 
<a class="special" href="$script_url?compile&2" target="bottom">Remote User Environment Variables</a> | 
<a class="special" href="$script_url?compile&3" target="bottom">Perl Program</a> | 
<a class="special" href="$script_url?compile&4" target="bottom">Mail Program</a><br>
<a class="special" href="$script_url?compile&5" target="bottom">Server Environment Variables</a> | 
<a class="special" href="$script_url?compile&6" target="bottom">Installed Perl Libraries</a> | 
<a class="special" href="$script_url?compile&7" target="bottom">Installed Perl Modules</a>
</center>

</body>
</html>
HTML
}

########################################################
# Bottom Header
########################################################
sub bottom_header {

print <<HTML;
<html>
<head>
<title>Virtual Solutions : ServerCheck</title>
<meta name="Author" content="Virtual Solutions at http://www.monster-submit.com/">
<meta name="Copyright" content="(c) Copyright 1999 - 2008 Virtual Solutions. All Rights Reserved.">
<!-- ServerCheck from Virtual Solutions at http://www.monster-submit.com/servercheck/ -->
<style>
.link {
	color:#7384BD; font-family: arial, helvetica, sans-serif; font-weight:bold; font-size:10px; text-decoration: none;
}
.link:hover {
	color:#7384BD; font-family: arial, helvetica, sans-serif; font-weight:bold; font-size:10px; text-decoration: underline;
}
.none {
	color:#000000; background-color: #FFFFFF; font-weight:none; text-decoration: none;
}
.special {
	color:#7294AF; text-decoration: none;
}
.special:hover {
	color:#C8D1D7; text-decoration: underline;
}
.special:visited {
	color:#7294AF; text-decoration: none;
}
.button {
	color:#000000; background-color: #C8D1D7; font-weight:none; text-decoration: none;
}
input, select, textarea	{
	color:#000000; background-color: #C8D1D7; font-weight:none; text-decoration: none;
}
.cellstyle1	{
	background-color: #C8D1D7;
}
.cellstyle2	{
	background-color: #DEE3E7;
}
.cellstyle3	{
	background-color: #EFEFEF;
}
.cellstyle4	{
	background-color: #FFFFFF;
}
.cellstyle5	{
background-color: #FFFFFF;
}
.cellstyle6c1 {
	background-color: red;
}
.cellstyle6b1 {
	background-color: #FFFFFF;
}
.cellstyle6c2 {
	background-color: green;
}
.cellstyle6b2 {
	background-color: #FFFFFF;
}
.cellstyle6c3 {
	background-color: yellow;
}
.cellstyle6b3 {
	background-color: #FFFFFF;
}
.fontstyle1	{
	color: #FFFFFF; font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 16px;
}
.fontstyle2	{
	color: #000000; font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 12px;
}
.fontstyle3	{
	color: #006699; font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10px;
}
.fontstyle4	{
	color: #006699; font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10px;
}
.fontstyle5	{
	color: #006699; font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10px;
}
.fontstyle6c1 {
	color: #FFFFFF; font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 12px;
}
.fontstyle6b1 {
	color: red; font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 12px;
}
.fontstyle6c2 {
	color: #FFFFFF; font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 12px;
}
.fontstyle6b2 {
	color: green; font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 12px;
}
.fontstyle6c3 {
	color: #000000; font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 12px;
}
.fontstyle6b3 {
	color: #000080; font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 12px;
}
body {
	background-color:#E5E5E5;
	scrollbar-face-color: #C8D1D7; scrollbar-highlight-color: #EAF0F7;
	scrollbar-shadow-color: #95AFC4; scrollbar-3dlight-color: #D6DDE2;
	scrollbar-arrow-color: #006699; scrollbar-track-color: #EFEFEF;
	scrollbar-darkshadow-color: #7294AF;
}
</style>
</head>

<body bgcolor="#E5E5E5" text="#000080">

<center>
HTML
}

########################################################
# Server
########################################################
sub server {

my ($parameter) = @_;
open(S, "</proc/$parameter");
$parameter = join("<BR>", <S>);
close(S);
return $parameter;
}

########################################################
# Compile Modules
########################################################
sub compile_modules {

/^.*\.pm$/ && /$ARGV[1]/i && push @mod, $File::Find::name;
}

###############################################
# Get Time
###############################################
sub get_time {

my @tb	= localtime(time);

my $ap	= "am";
$ap	= "pm" if ($tb[2] >= 12);
$tb[2]	-= 12 if ($tb[2] > 12);
$tb[4]++;
for (0..4) { $tb[$_] = sprintf("%02d", $tb[$_]); }
$tb[5]	+= 1900;

return "$tb[2]:$tb[1]:$tb[0]$ap $tb[4]/$tb[3]/$tb[5]";
}

