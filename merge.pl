#!/usr/bin/perl
# *************************************************************************
#             merge.pl
# 
#   Tue Oct  5 12:22:33 2004
#   Copyright  2004  Alliance MCA
#   Written by Morad Igmir (and maintained by antoine@alliancemca.net)
# **************************************************************************

# This script merge a charmap file with an Unicode character description file


sub usage()
	{
	print "Usage : merge.pl [charmap_file] [UnicodeData_file]\n" and exit ;
	}
usage unless (@ARGV eq "2"); 
die "error ( $! )" unless open (CHARMAP,$ARGV[0]);
die "error ( $! )" unless open (UNICODE,$ARGV[1]);
while (<UNICODE>)
	{
	chomp $_;
	$_ =~ s/\t//;
	@tablo1= split /\;/, $_;
	$octale=$tablo1[0];
	$control{$octale} = $tablo1[2];
	
	}
close UNICODE;
while (<CHARMAP>)
	{
	print $_ and next unless $_ =~/^0x/;
	chomp $_;
	@tablo2 = split /\t/,$_;
	my $var=uc(substr($tablo2[1],2,4));
	$var =~ s/\t//;
	chomp ($line= "$tablo2[0]\;$tablo2[1]\;$control{$var}\;$tablo2[2]$tablo2[3]$tablo2[4]");
	$line =~ s/\t//g;
	$line =~ s/\;/\t/g;
	print $line."\n";
	
	}
close CHARMAP;
print STDERR "\nC'est fini ##### va !!!\n";
exit;
