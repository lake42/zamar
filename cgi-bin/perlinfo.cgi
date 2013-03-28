#!/usr/bin/perl

use strict;
use CGI;
use CGI::Carp qw(fatalsToBrowser);
use File::Find;


## Do not buffer the output - just send it to the browser
$| = 1;


## Declaring some objects and variables we will need.
my $q = new CGI;

my $where_sendmail = `whereis sendmail`;
my @sendmail = split(" ", $where_sendmail);
my $where_perl = `whereis perl`;
my @perl = split(" ", $where_perl);
my $UID = getpwuid($>);
my $EUID = getpwuid($<);
my $case_num = "IDS-0000000";


## Print the header and start the HTML
print $q->header();
print $q->start_html();


## Header to explain why this script is on the site
print <<END;
<table border="0" width="100%">
  <tr>
    <td width="100%">
      This script will display available information about Perl with regard to paths, environmental variables, and all installed modules.  If a module version is available from the module itself it will also be displayed.  This script needs to look for a lot of information so please be patient as it completes it's task.  
    </td>
  </tr>
</table>
<br><br>
END

## Display server paths, info, and locations
print qq!<table width="100%" border="0"><tr><td colspan="2" bgcolor="#CCCCCC" align="center"><font size="+1"><b>Server Versions, Paths, and Information</b></font></td></tr>!;
print qq!<tr><td width="25%" align="right"><b>Path to Perl:</b></td><td width="75%">$^X</td></tr>!;
print qq!<tr><td width="25%" align="right"><b>Perl Version:</b></td><td width="75%">$]</td></tr>!;
print qq!<tr><td width="25%" align="right"><b>Server OS:</b></td><td width="75%">$^O</td></tr>!;
print qq!<tr><td width="25%" align="right"><b>UID:</b></td><td width="75%">$UID ($>)</td></tr>!;
print qq!<tr><td width="25%" align="right"><b>Effective UID:</b></td><td width="75%">$EUID ($<)</td></tr>!;

print qq!<tr><td width="25%" align="right" valign="top"><b>Perl Location:</b></td><td width="75%">!;
foreach(@perl)
{
	next if $_ =~ /:/;
	print "$_<br>\n";
}
print qq!</td></tr>!;

print qq!<tr><td width="25%" align="right" valign="top"><b>Sendmail Location:</b></td><td width="75%">!;
foreach(@sendmail)
{
	next if $_ =~ /:/;
	print "$_<br>\n";
}
print qq!</td></tr>!;

print qq!<tr><td width="25%" align="right" valign="top"><b>Perl Module Locations:</b></td><td width="75%">!;
@INC = reverse(@INC);
foreach(@INC)
{
	$_ = "Current directory ($ENV{DOCUMENT_ROOT})" if $_ =~ /^\./;
	print "$_<br>\n";
}
print qq!</td></tr>!;

print qq!</table><p>&nbsp;</p>!;


## List all the available environmental variables
print qq!<table width="100%" border="0"><tr><td colspan="2" bgcolor="#CCCCCC" align="center"><font size="+1"><b>Environmental Variables</b></font></td></tr>!;

while(my($key, $value) = each(%ENV))
{
	print qq!<tr><td width="25%" align="right"><b>$key:</b></td><td width="75%">$value</td></tr>!;
}

print qq!</table><p>&nbsp;</p>!;


## Let's find all the modules installed on this server
## We will display the name of the module, it's version number, and description
## of what it does if available.

my @mods;
my %modules;

## Open the table up so we can start spitting out our data
print qq!<table border="0" width="100%"><tr><td width="100%" colspan="4" bgcolor="#CCCCCC" align="center"><font size="+1"><b>Installed Modules</b></font></td></tr><tr><td width="40%"><b>Module Name</b></td><td width="10%"><b>Version</b></td><td width="40%"><b>Module Name</b></td><td width="10%"><b>Version</b></td></tr></table>!;


## Get a list of all our mods
find(\&getmods,@INC);

## Need to create a hash with a all lowercase version of all our mods 
## so that we can alphabetize correctly.
foreach my $item (@mods)
{
	my $lc = lc($item);
	$modules{$lc} = $item;
}

@mods = sort keys(%modules);
my $count = @mods;
my $i = 0;

while($count >= $i)
{
	
	## Set the name of the module we are about to print
	my $mod_name1 = $modules{$mods[$i]};
	
	## Get the version of the module
	my $mod_ver1 = `$^X -m$mod_name1 -e 'print \$${mod_name1}::VERSION' 2>/dev/null`;
    	$mod_ver1 =~ s/^\s*(.*?)\s*$/$1/;  ## Remove whitespace
    	if($mod_ver1 =~ /[a-zA-Z]/){$mod_ver1 = "";}  ## Null the version if it is letters not numbers
    	
    	
    	## Increase the iteration by one so we can have two columns
    	$i++;
    	
    	
	## Set the name of the module we are about to print
	my $mod_name2 = $modules{$mods[$i]};
	
	## Get the version of the module
	my $mod_ver2 = `$^X -m$mod_name2 -e 'print \$${mod_name2}::VERSION' 2>/dev/null`;
    	$mod_ver2 =~ s/^\s*(.*?)\s*$/$1/;  ## Remove whitespace
    	if($mod_ver2 =~ /[a-zA-Z]/){$mod_ver2 = "";}  ## Null the version if it is letters not numbers
    	
    	
    	## Increase the iteration by one again so we don't duplicate our work
    	$i++;
    	
    	
    	print qq!<table border="0" width="100%"><tr><td width="40%">$mod_name1</td><td width="10%">$mod_ver1</td><td width="40%">$mod_name2</td><td width="10%">$mod_ver2</td></tr></table>!;
    	
    	undef $mod_name1;
    	undef $mod_name2;
    	undef $mod_ver1;
    	undef $mod_ver2;
}


## Print a footer to indicate all modules have been listed
print <<END;
<table border="0" width="100%" bgcolor="#CCCCCC">
  <tr>
    <td width="100%">
      <p align="center">Perl Info script</p>
    </td>
  </tr>
</table>
END


## End the page
print $q->end_html();




##################################
##                              ##
##     All Functions Follow     ##
##                              ##
##################################


sub getmods
{
	if ($File::Find::name =~ /\.pm$/){
		open(MODFILE,$File::Find::name) || return;
		while(<MODFILE>){
			if (/^ *package +(\S+);/){
				push (@mods, $1);
				last;
			}
		}
	}
}
