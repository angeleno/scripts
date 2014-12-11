#!/usr/bin/perl

use strict;
use warnings;
use Date::Calc qw(:all);
use Date::Parse;

my @values = split(/\n/, `systeminfo`);

# ensure we do not un-neccessarily do lots of string matching
# 
my $btcheck;
my $tpmcheck;
my $apmcheck;
my $vmusecheck;

print "\n";

foreach(@values)
{
	# if matches system boot time
	if( !$btcheck && $_ =~ /System Boot Time/)
	{
		my $bootDate = $_;
		$bootDate =~ s/System Boot Time\:\W+//;
		# strptime hates commas
		$bootDate =~ s/,//;
		
		my ($ss1,$mm1,$hh1,$day1,$month1,$year1,$zone1) = strptime($bootDate);
		my ($ss2,$mm2,$hh2,$day2,$month2,$year2,$wday,$yday,$isdst) = localtime();
		
		my ($days, $hours, $minutes, $seconds) =
		Delta_DHMS( $year1, $month1, $day1, $hh1, $mm1, $ss1,  # earlier
					$year2, $month2, $day2, $hh2, $mm2, $ss2); # later
		
		$btcheck = 1;
		printf "%-25s --> $days-days, $hours:$minutes:$seconds\n", "Uptime";
	}
	elsif(!$tpmcheck && $_ =~ /Total Physical Memory/)
	{	
		$btcheck = 1;
		my $totPhyMem = $_;
		$totPhyMem =~ s/[^0-9]//g;
		$totPhyMem /= 1024.0;
		printf "%-25s --> %-5.3f GB\n", "Total Physical Memory", $totPhyMem;
	}
	elsif(!$apmcheck && $_ =~ /Available Physical Memory/)
	{
		$apmcheck = 1;
		my $availPhyMem = $_;
		$availPhyMem =~ s/[^0-9]//g;
		$availPhyMem /= 1024.0;
		printf "%-25s --> %-5.3f GB\n", "Available Physical Memory", $availPhyMem;
	}
	elsif(!$vmusecheck && $_ =~ /Virtual Memory\: In Use/)
	{
		$vmusecheck = 1;
		
		my $vmInUse = $_;
		$vmInUse =~ s/[^0-9]//g;
		$vmInUse /= 1024.0;
		printf "%-25s --> %-5.3f GB\n", "Virtual Memory: In Use", $vmInUse;
		
		# since this is the last stat in the list that i am printing
		#
		last;
	}
}

my $numProcesses = `tasklist | grep -v Services | wc -l`;
printf "%-25s --> %-5d \n", "Number of Processes", $numProcesses;



