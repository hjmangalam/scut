#!/usr/bin/perl

# $Id$

# usage: this is a cgi that is supposed to respond to input provided by
# the scutx.form.html page.

# the following vars are set automagically from the installation script
# or can be manually edited if you continue to have problems.
##############################################################################
my $server         = "moo.nac.uci.edu";  # What YOUR server is
my $htmlpathtoform = "scut/index.html";     # Where/what the form is
my $SCUTERR        = 1;  # whether to print out the error onto the web page.
my $webpathtodata  = "scut";                # where your base httpd scut dir is
my $tmppath        = "/tmp/scut";           # Where you want to store your temp stuff
my $scutapp        = "/usr/local/bin/scut";  # The app name of the scut3 exe
my $cols           = "/usr/local/bin/cols";
##############################################################################
# Version now taken care of by grabbing it out of the scut executable itself

use CGI qw/:standard :html3/ ;
use Time::localtime;
$tm = localtime;
my $gb;

print header,
   start_html('scut results');

# Basically have to parse the input via param() calls, build the commandline
# submit it, perhaps grab the results and munge it into a form to be sent back
# to the user.

# get the PID of this process, make the directory, based on an identifiable root and the PID
my $suffix = $$ . time;  # cat time to PID to make it more fine-grained
my $dirname = "/tmp/scut" . $suffix;
mkdir $dirname, 666;
chmod 0777, $dirname;

#Open the scuti4 error log file
my $logname = $dirname . "/scut.errlog." . $suffix; # the output of this is the input to scut
open(LOG, ">$logname") or die "Can't open the damn error log file: $logname!\n";
# What should be done here is that if the ERROR LOG button is clicked, it should write something
# to the errror log at every logic step to show how far it gets when it dies

#compose the header for the output files:

# ================  And process the input - get params  =========================
# params to be processed:
# "NEEDLE_FILE"
# "HAYSTACK_FILE"
# "NEEDLE_KEY_COL"
# "HAYSTACK_KEY_COL"
# "NEEDLE_DELIM"
# "HAYSTACK_DELIM"
# "NEEDLE_COLS"
# "HAYSTACK_COLS"
# 
# "OUTPUT_DELIM"
# "LABELS"

print "<font size=5 color=\"red\">WWW scut Analysis</FONT><P>",
"<SMALL> by <A HREF=\"mailto:harry.mangalam\@uci.edu?Subject=scut comment\">Harry Mangalam</A></SMALL>";

print "<BR>&#187; Results from <A HREF=\"http://$server/$htmlpathtoform\"> <b>$server</b> </A> on ";

printf "<b> %02d-%02d-%04d </b> (d-m-y).\n", $tm->mday, ($tm->mon)+1, ($tm->year)+1900;


if (param) {
   # ========================= Sequence loading params ==========================
	if (!defined $NEEDLE_FILE) {
		$NEEDLE_FILE = param('NEEDLE_FILE');
		my $TMPFILE = $dirname . "/needle";
      open (TMP, ">$TMPFILE") or die "Can't open the damn file: $TMPFILE!\n";
      while (<$NEEDLE_FILE>) {
         $_ =~ s/\r\n/\n/g; # change all DOS eol to newlines
         $_ =~ s/\r/\n/g; # change all Mac eol to newlines
         $_ =~ s/\n+/\n/g; #then change all multiple newlines to a single
         print TMP $_;
      }
      close TMP;  # actually, on open, this is closed automatically, no?
	}

	if (!defined $HAYSTACK_FILE) {
		$HAYSTACK_FILE = param('HAYSTACK_FILE');
		my $TMPFILE = $dirname . "/haystack";
      open (TMP, ">$TMPFILE") or die "Can't open the damn file: $TMPFILE!\n";
      while (<$HAYSTACK_FILE>) {
         $_ =~ s/\r\n/\n/g; # change all DOS eol to newlines
         $_ =~ s/\r/\n/g; # change all Mac eol to newlines
         $_ =~ s/\n+/\n/g; #then change all multiple newlines to a single
         print TMP $_;
      }
      close TMP;  # actually, on open, this is closed automatically, no?
		
	}



#	if (!defined $NEEDLE_KEY_COL) {
		$NEEDLE_KEY_COL = param('NEEDLE_KEY_COL');
		#print "<b>NEEDLE_KEY_COL=$NEEDLE_KEY_COL</b><br>\n";
		
#	}

#	if (!defined $HAYSTACK_KEY_COL) {
		$HAYSTACK_KEY_COL = param('HAYSTACK_KEY_COL');
		#print "<b>$HAYSTACK_KEY_COL</b><br>\n";
#	}

#	if (!defined $NEEDLE_DELIM) {
		$NEEDLE_DELIM = param('NEEDLE_DELIM');
		#print "<b>$NEEDLE_DELIM</b><br>\n";
#	}

#	if (!defined $HAYSTACK_DELIM) {
		$HAYSTACK_DELIM = param('HAYSTACK_DELIM');
#	}

#	if (!defined $NEEDLE_COLS) {
		$NEEDLE_COLS = param('NEEDLE_COLS');
#	}

#	if (!defined $HAYSTACK_COLS) {
		$HAYSTACK_COLS = param('HAYSTACK_COLS');
#	}
	
#	if (!defined $OUTPUT_DELIM) {
      $OUTPUT_DELIM = 'TAB';
		$OUTPUT_DELIM = param('OUTPUT_DELIM');
#	}

#	if (!defined $LABELS) {
		$LABELS = param('LABELS');
		#print "<b>=LABELS = $LABELS</b><br>";
		
		$CASE_INSEN = param('CASE_INSEN');
		#print "<b>=CASE_INSEN = $CASE_INSEN</b><br>";
#	}
}
# So that's the end of getting all the params from the form.  NOW go do something
# with them.  Process them into formal options.  If they aren't defined or
# otherwise required, the string can be declared as "".

# ============================ End getting params ==============================

#set up an error file to accept the errors from scut,
$scutErrFile = $dirname . "/scutErr";

# for the scuti error log, can simply start a log output from here to be chatty as we want


# so, without any error handling, try it out.

##  Build the scut command line with all the options needed  ####
# So now we build the commmandine with the full path of the app (set above)
$scutcmdline = $scutapp;  # /usr/local/bin/scut (or whatever - where the app lives

# the -H flag is not needed by this form anymore.  -H now either generates a full HTML
# page by itself (-H0) or a partial one including the TOC (-H1)
$scutcmdline .= " --f1=$dirname/needle   --f2=$dirname/haystack --id1='$NEEDLE_DELIM' --id2='$HAYSTACK_DELIM' --k1=$NEEDLE_KEY_COL --k2=$HAYSTACK_KEY_COL --c1='$NEEDLE_COLS' --c2='$HAYSTACK_COLS' --od='$OUTPUT_DELIM' ";


if ($LABELS =~ /1/) {$scutcmdline .= " --labels";}

if ($CASE_INSEN =~ /on/){$scutcmdline .= " --nocase ";}

$scutcmdline .= " 2> $logname";

print "<hr>\n<br>\n<h2>Previews of Inputs and Output</h2>";

my $col_delim = "\t";
if ($NEEDLE_DELIM !~ /TAB/) {$col_delim = $NEEDLE_DELIM}
print "<h3>Column-aligned preview of the Needle file:</h3>";
print "<textarea rows=12 cols=200>\n";
system("head -55 $dirname/needle | $cols --ml=55 --delim=$col_delim");
print "</textarea>\n";

$col_delim = "\t";
if ($HAYSTACK_DELIM !~ /TAB/) {$col_delim = $HAYSTACK_DELIM}
print "<h3>Column-aligned preview of the Haystack file:</h3>";
print "<textarea rows=12 cols=200>\n";
system("head -55 $dirname/haystack | $cols --ml=55 --delim=$col_delim");
print "</textarea>\n";

$col_delim = "\t";
if ($OUTPUT_DELIM !~ /TAB/) {$col_delim = $OUTPUT_DELIM}
my $output = $dirname . "/scut_output";
print "<h3>Column-aligned preview of the resulting Output:</h3>";
print "<textarea rows=12 cols=200>\n";
system("$scutcmdline |tee $output | $cols --ml=55 --delim='$col_delim'; gzip $output");
print "</textarea>\n";

print "<hr>\n<br>\n<h2>Results</h2>";
my $URL = "http://" . $server . $output . ".gz";
my $infoline = "<P><b><a href=" . $URL . ">The entire gzipped output can be retrieved at this link.</a></b><P>";
print $infoline;

print "<h3>The Command Line used to generate these results was:</h3><pre> $scutcmdline </pre><P>\n";

#if (defined $SCUTERR){
   print "<hr noshade size=5> <h3>Log from scut</h3><pre>", `cat $logname;`, "</pre>";
#}

#print "<pre>Also re-executing to the error dir via system():</pre>\n";
#system("$scutcmdline");


#and delete all the files that are no longer needed
#unlink "$tmpfile", "$cmdfile", "$outname", "$ErrFile";

print "</BODY>\n</HTML>\n"; #end of form, body, html
