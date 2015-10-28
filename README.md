# scut, cols, and stats

by Harry Mangalam <harry.mangalam@uci.edu> 
v0.5, Apr 3rd, 2012

## Summary

'scut' is a short perl script that acts as a better (if slower) 'cut', and  
extracts arbitrary columns to be selected based on regexes you supply.  It also has
a 'join' function not unlike the *nix
[join](http://www.ibm.com/developerworks/linux/tutorials/l-gnutex/) 
(search for 'join') command.

Being unoptimized perl, it is considerably slower than 'cut' but it can do
things that cut can't dream of, so if you have 100s of GB of input to slice
& dice, it may be worthwhile to spend some time learning the finer points
of 'cut' and 'awk', but it you just need to chew thru 100s of MB to GBs of text,
scut may be of interest.

In addition to scut, there are 2 other small utilities here.

'cols' is a utility to 'columnize' lots of irregularly spaced data,
developed with and often used with scut.

Both 'scut' and 'cols' are documented in the included 
[scut_cols_HOWTO.html](http://moo.nac.uci.edu/~hjm/scut_cols_HOWTO.html)

In addition, there is a crude web interface to scut (webscut) to allow naive users
access to its dubious charms.  Both the form and perl cgi are in the webscut dir,
but are sorely lacking in documentation.  If you want to see what it looks
like in action, try: <http://moo.nac.usi.edu/scut>

'stats' is a utility to consume all numeric-like data fed to it via STDIN
and emit some useful descriptive statistics. 'stats -h' will give you all 
the help you need.

eg, calculate the file size distribution in the current directory:

````
   $ ls -l | cut -c31-42 |stats --dist=2 --x=20 --y=10
or $ ls -l | scut -f=4  |stats --dist=2 --x=20 --y=10

# which yields:

   Sum       158401735            158.4 MB total
   Number    503                  in 503 files
   Mean      314913.986083499     average size of file is 315 KB
   Median    10204                median size is 10 KB
   Mode      1024                 mode is 1024 due to ..
   NModes    33                   .. 33 directories
   Min       0                    at least 1 empty file
   Max       27135470             got a whomper of a file at 2.7 MB
   Variance  2903105341782.66     huge variance
   Std_Dev   1703850.15238508     etc
   SEM       75970.9233614217
   Skew      12.1873963279124
   Std_Skew  111.588464543135
   Kurtosis  235.291925985398

   Distribution
   X BinSize 0.186431547
   Y BinSize  18

   |    *
   |
   |   * *
   |
   |
   |      *
   |  *
   |
   |       *
   |**      ************
   +--------------------

````
