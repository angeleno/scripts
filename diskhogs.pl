#!/usr/bin/perl
use strict;
use warnings;

# du for disk-usage
#  k -> for values in kilo-bytes
#  sort in descending order by numbers
#  pipe to awk for formatted printing, currently print entries over 200KB only
#
system('du -sk * | sort -n -r | awk "{if($1 > 200) printf \"%2d %10.3f %-1s ---- %-25s \n\", NR, $1/1024, \"MB\", $2 }"');
