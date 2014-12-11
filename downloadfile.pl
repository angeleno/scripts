#!/usr/bin/perl 
use strict;
use warnings;

my $currDir = `pwd`;
# chomp it else curl will try to fetch file as folder!
chomp($currDir);

sub GetFiles
{
	my @urlList = @_;
	foreach(@urlList)
	{
		my $url = $_;
		my $leaf = $url;
		
		# just get the leaf from url
		#
		$leaf =~ s/^.*\///;
		
		# in case the leaf has %20 embedded as space then replace by . 
		# for all instances in the string
		#
		$leaf =~ s/%20/\./g;
		my $fullPath = $currDir . "\\" . $leaf;
		
		print "fetching file to $fullPath\n";
		system("curl $url -o $fullPath");
	}
}

GetFiles(@ARGV);

