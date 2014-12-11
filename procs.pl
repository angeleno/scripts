#!/usr/bin/perl
use strict;
use warnings;
#
# tasklist is like ps on nix systems
#	typical output is like this:
# 		Image Name                     PID Session Name        Session#    Mem Usage
# 		========================= ======== ================ =========== ============
# 		System Idle Process              0 Services                   0         24 K
# 		System                           4 Services                   0        504 K
# 		smss.exe                       344 Services                   0      1,432 K
# 		csrss.exe                      508 Services                   0      5,528 K
# 		wininit.exe                    584 Services                   0      5,408 K
# 		csrss.exe                      608 Console                    1     46,092 K
# 		services.exe                   656 Services                   0     14,732 K
#
#	here I am not interested in Services, thus grepping for applications (basically anything that is not Services)
#	awk script then condenses data per process
#	which is then sorted in reverse order so the executable consuming max memory is at top
#	again printed with awk (so as to get line#)
#
#	Final output is like:
#		Sr   Process                     Instances           Total Memory (MB)
#       1   chrome.exe                         24           1655.000
#       2   vmware-vmx.exe                      1           681.000
#       3   OUTLOOK.EXE                         1           187.000
#       4   doug.exe                            1           170.000
#       5   dwm.exe                             1           115.000
#       6   explorer.exe                        1           103.000
#       7   perl.exe                            2           89.000
#       8   iexplore.exe                        2           80.000
#       9   AcroRd32.exe                        2           72.000
#      10   communicator.exe                    1           62.000
#      11   vmware.exe                          1           61.000
#
# it is important to take off , from numbers. Once numbers start going above million (I guess above 2Gigs things don't work)
# niether, sort, awk or gawk can handle such numbers
#
my $taskList = `tasklist | grep Console`;
my $numProcs = $taskList =~ tr/\n//;
chomp($numProcs);
print "\n$numProcs user-processes running on system, details:\n\n";

system('tasklist | grep Console | sed -e "s%,%%g" | awk "BEGIN{numProcs = 0;}{	numProcs++;	procNames[$1] = $1; procInstances[$1]++; procMem[$1] += $5;}END{for(idx in procInstances){printf \"%-25s  %10d           %-20.3f\n\", procNames[idx], procInstances[idx], procMem[idx]/1024;}}" | sort -nrk 3 | awk "BEGIN{printf \"%2s   %-25s  %10s           %-20s\n\", \"Sr\", \"Process\", \"Instances\", \"Total Memory (MB)\"; counter = 1;}{printf \"%2d   %s\n\", counter++, $0;}"');
