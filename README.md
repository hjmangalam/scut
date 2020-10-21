# scut, cols, and stats

by Harry Mangalam <harry.mangalam@uci.edu> 
updated Oct 21, 2020

## Summary

'scut' is a short perl script that acts as a better (if slower) 'cut', and  
extracts arbitrary columns to be selected based on regexes you supply.  It also has
a 'join' function not unlike the *nix
[join](http://www.ibm.com/developerworks/linux/tutorials/l-gnutex/) 
(search for 'join') command.

Being unoptimized perl, it is considerably slower than 'cut' but it can do
things that cut can't dream of, so if you have 100s of GB of input to slice
& dice, it may be worthwhile to spend some time learning the finer points
of 'cut' and 'awk', but it you just need to chew thru 100s of MB to GBs 
of complext text, scut may be of interest.

In addition to scut, there are 2 other small utilities here.

'cols' is a utility to 'columnize' lots of irregularly spaced data,
developed with and often used with scut.  It is similar to column/columns.

Both 'scut' and 'cols' are documented in the included 
[scut_cols_HOWTO.html](http://moo.nac.uci.edu/~hjm/scut_cols_HOWTO.html)

'stats' is a nther Perl utility to consume all numeric-like data fed to it via STDIN
and emit some useful descriptive statistics. 'stats -h' will give you all 
the help you need.
It also has the ability to stream-transform numeric
input and apply stats on those transformed data or print it to STDOUT without
the stats calculation.   

Those transforms are:  log10, ln, sqrt, x^2, x^3, 1/x, sin, cos, tan, asin,
acos, atan, round, abs, exp, trunc (integer part), frac (decimal part)

It can also emit only the value you're interested in.  So if you  only want
the 'Median', if you pipe some stream of numbers | 'stats --medium', it will
provide an unadorned single value of the median.  

eg, calculate the file size distribution in the current directory:

````
# try the following with and without the '--xf=ln' and the '--gfmt'

   $ ls -l | awk '{print $5}' |stats --gfmt --xf=ln --dist=2 --x=20 --y=10
or $ ls -l | scut -f=4        |stats --dist=2 --x=20 --y=10

# which yields:

Sum       694.1
Number    172
Mean      4.03546
Median    4.14357
Mode      3.61236
NModes    11
Min       0
Max       8.45349
Range     8.45349
Variance  2.41354
Std_Dev   1.55356
SEM       0.118458
95% Conf  3.80329 to 4.26764
          (for a normal distribution - see skew)
Skew      -0.300842
          (skew = 0 for a symmetric dist)
Std_Skew  -1.61074
Kurtosis  0.483482
          (K=3 for a normal dist)


Distribution
X BinSize 0.422674703876582
Y BinSize  2.66666666666667

YMax:24
      |           *        
      |         *          
      |        *           
      |            *       
      |     *    *         
      |                    
      |      **     *      
      |    *          *    
      |**            *     
      |  **            ****
      |--------------------
  X Min               X Max
   0.00                8.45 


````
